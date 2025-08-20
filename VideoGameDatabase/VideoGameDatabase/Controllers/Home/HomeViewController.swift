//
//  HomeViewController.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//
import UIKit
import SDWebImage

final class HomeViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var newLaunchesCollectionView: UICollectionView!
    @IBOutlet private weak var genresCollectionView: UICollectionView!
    @IBOutlet private weak var trendingCollectionView: UICollectionView!
    @IBOutlet private weak var genresCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var trendingCollectionViewHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    private let newLaunchesDataSource = NewLaunchesDataSource()
    private let genresDataSource = GenresDataSource()
    private let trendingDataSource = TrendingDataSource()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        registerCells()
        bindViewModel()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeights()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        SearchBarStyler.applyDark(searchBar)
        
        if let clearButton = searchBar.searchTextField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = .lightGray
        }
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        
        newLaunchesCollectionView.dataSource = newLaunchesDataSource
        newLaunchesCollectionView.delegate = newLaunchesDataSource
        
        genresCollectionView.dataSource = genresDataSource
        genresCollectionView.delegate = genresDataSource
        
        trendingCollectionView.dataSource = trendingDataSource
        trendingCollectionView.delegate = trendingDataSource
    }
    
    private func registerCells() {
        newLaunchesCollectionView.register(UINib(nibName: BannerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BannerCollectionViewCell.reuseIdentifier)
        genresCollectionView.register(UINib(nibName: GenreCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.reuseIdentifier)
        trendingCollectionView.register(UINib(nibName: GameCardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            
            self.newLaunchesDataSource.games = self.viewModel.newLaunchGames
            self.genresDataSource.genres = self.viewModel.genres
            self.trendingDataSource.games = self.viewModel.trendingGames
            
            self.newLaunchesCollectionView.reloadData()
            self.genresCollectionView.reloadData()
            self.trendingCollectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
    }
    
    private func updateCollectionViewHeights() {
        genresCollectionViewHeightConstraint.constant = genresCollectionView.collectionViewLayout.collectionViewContentSize.height
        trendingCollectionViewHeightConstraint.constant = trendingCollectionView.collectionViewLayout.collectionViewContentSize.height
        view.layoutIfNeeded()
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        
        guard let tab = tabBarController else { return }
        tab.selectedIndex = 1
        
        if let nav = tab.viewControllers?[1] as? UINavigationController {
            if let discover = (nav.topViewController as? DiscoverViewController)
                ?? (nav.viewControllers.first as? DiscoverViewController) {
                discover.handleExternalSearch(query)
                return
            }
        } else if let discover = tab.viewControllers?[1] as? DiscoverViewController {
            discover.handleExternalSearch(query)
            return
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didRequestDiscoverSearch,
                                            object: nil,
                                            userInfo: ["query": query])
        }
    }
}
