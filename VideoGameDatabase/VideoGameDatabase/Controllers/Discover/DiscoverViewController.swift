//
//  DiscoverViewController.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//
import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var browseContainer: UIView!
    @IBOutlet private weak var genresCollectionView: UICollectionView!
    @IBOutlet private weak var browseGridCollectionView: UICollectionView!
    @IBOutlet private weak var resultsContainer: UIView!
    @IBOutlet private weak var resultsHeaderLabel: UILabel!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var resultsCollectionView: UICollectionView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    private var viewModel: DiscoverViewModelProtocol = DiscoverViewModel()
    private let chipsDS   = DiscoverChipsDataSource()
    private let browseDS  = GameGridDataSource()
    private let resultsDS = GameGridDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollections()
        hookNotifications()
        bindViewModel()
        viewModel.loadInitial()
        setupNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchBar.delegate = self
        SearchBarStyler.applyDark(searchBar)
        
        browseContainer.isHidden  = false
        resultsContainer.isHidden = true
        resultsHeaderLabel.isHidden = true
        emptyLabel.isHidden = true
    }
    
    private func setupCollections() {
        genresCollectionView.register(
            UINib(nibName: DiscoverGenreChipCell.reuseIdentifier, bundle: nil),
            forCellWithReuseIdentifier: DiscoverGenreChipCell.reuseIdentifier
        )
        let gameNib = UINib(nibName: GameCardCollectionViewCell.reuseIdentifier, bundle: nil)
        browseGridCollectionView.register(gameNib,
                                          forCellWithReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier)
        resultsCollectionView.register(gameNib,
                                       forCellWithReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier)
        
        genresCollectionView.dataSource = chipsDS
        genresCollectionView.delegate   = chipsDS
        
        browseGridCollectionView.dataSource = browseDS
        browseGridCollectionView.delegate   = browseDS
        
        resultsCollectionView.dataSource = resultsDS
        resultsCollectionView.delegate   = resultsDS
        
        [browseGridCollectionView, resultsCollectionView].forEach {
            if let flow = $0?.collectionViewLayout as? UICollectionViewFlowLayout {
                flow.scrollDirection = .vertical
                flow.estimatedItemSize = .zero
                flow.minimumInteritemSpacing = 10
                flow.minimumLineSpacing = 10
            }
        }
        
        if let flow = genresCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
            flow.estimatedItemSize = .zero
            flow.minimumInteritemSpacing = 10
            flow.minimumLineSpacing = 10
        }
        genresCollectionView.allowsMultipleSelection = true
        
        //  TODO: tab card -> Detail
        [browseDS, resultsDS].forEach { dataSource in
            dataSource.onGameSelected = { [weak self] game in
                self?.openGameDetail(with: game.id)
            }
        }
        
        chipsDS.onToggle = { [weak self] genre, _ in
            self?.viewModel.toggleGenre(slug: genre.slug)
        }
    }
    
    private func openGameDetail(with id: Int) {
        let controller = DetailHostViewController.instantiate(gameId: id)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func hookNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleIncomingSearch(_:)),
            name: .didRequestDiscoverSearch,
            object: nil
        )
    }
    
    private func bindViewModel() {
        viewModel.onUpdateBrowse = { [weak self] in
            guard let self = self else { return }
            self.chipsDS.genres = self.viewModel.chips
            self.chipsDS.selectedSlugs = self.viewModel.selectedSlugs
            self.genresCollectionView.reloadData()
            
            self.browseDS.games = self.viewModel.browseGames
            self.browseGridCollectionView.reloadData()
        }
        
        viewModel.onUpdateResults = { [weak self] in
            guard let self = self else { return }
            self.resultsHeaderLabel.isHidden = false
            self.resultsHeaderLabel.text = self.viewModel.headerText
            
            self.resultsDS.games = self.viewModel.resultGames
            self.emptyLabel.isHidden = !self.viewModel.resultGames.isEmpty
            self.resultsCollectionView.reloadData()
        }
    }
    
    // MARK: - Mode switch
    private func switchToResultsMode(query: String) {
        browseContainer.isHidden  = true
        resultsContainer.isHidden = false
        resultsHeaderLabel.isHidden = false
        resultsHeaderLabel.text = "Searching…"
        emptyLabel.isHidden = true
        searchBar.showsCancelButton = true
        
        viewModel.search(query)
    }
    
    private func switchToBrowseMode() {
        browseContainer.isHidden  = false
        resultsContainer.isHidden = true
        resultsHeaderLabel.isHidden = true
        emptyLabel.isHidden = true
        searchBar.showsCancelButton = false
        searchBar.text = nil
    }
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleGenreSelectionFromHome(_:)),
            name: .didSelectGenreOnHome,
            object: nil
        )
    }
    
    @objc private func handleGenreSelectionFromHome(_ notification: Notification) {
        guard let slug = notification.userInfo?["genreSlug"] as? String else { return }
        switchToBrowseMode()
        
        viewModel.selectGenre(by: slug)
    }
    // MARK: - Actions
    @IBAction private func filterButtonTapped(_ sender: UIButton) {
        let vc = FilterViewController(nibName: "FilterViewController", bundle: nil)
        vc.current = viewModel.currentFilters
        vc.onApply = { [weak self] f in self?.viewModel.apply(f) }
        vc.onClear = { [weak self] _ in self?.viewModel.clearFilters() }
        presentSheet(vc)
    }
    
    // MARK: - Notifications
    @objc private func handleIncomingSearch(_ note: Notification) {
        if let query = note.userInfo?["query"] as? String {
            searchBar.text = query
            switchToResultsMode(query: query)
        }
    }
    
    // MARK: - Helpers
    private func presentSheet(_ vc: UIViewController) {
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        present(vc, animated: true)
    }
    func handleExternalSearch(_ query: String) {
        loadViewIfNeeded()
        searchBar.text = query
        switchToResultsMode(query: query)
    }
}

// MARK: - UISearchBarDelegate
extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        switchToResultsMode(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        switchToBrowseMode()
    }
}
