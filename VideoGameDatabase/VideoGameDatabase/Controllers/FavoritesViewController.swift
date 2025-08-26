import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
    @IBOutlet private weak var resultsCountLabel: UILabel!
    // MARK: - Properties
    
    private var viewModel: FavoritesViewModelProtocol = FavoritesViewModel()
    private let dataSource = TrendingDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
        bindViewModel()
        resultsCountLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavoriteGames()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
        
        dataSource.onGameSelected = { [weak self] game in
            self?.openGameDetail(with: game.id)
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: GameCardCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            guard let self = self else { return }
            
            self.dataSource.games = self.viewModel.favoriteGames
            self.collectionView.reloadData()
            let favoritesCount = self.viewModel.favoriteGames.count
            let favoritesIsEmpty = favoritesCount == 0
            self.emptyStateLabel.isHidden = !self.viewModel.favoriteGames.isEmpty
            self.collectionView.isHidden = self.viewModel.favoriteGames.isEmpty
            self.resultsCountLabel.text = "Found \(favoritesCount) items"
            self.resultsCountLabel.isHidden = favoritesIsEmpty
        }
        
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
    }
    
    // MARK: - Navigation
    
    private func openGameDetail(with id: Int) {
        let controller = DetailHostViewController.instantiate(gameId: id)
        navigationController?.pushViewController(controller, animated: true)
    }
}
