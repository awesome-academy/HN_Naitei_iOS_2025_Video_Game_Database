import UIKit

final class DetailHostViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var heroView: HeroHeaderView!
    @IBOutlet private weak var titleView: TitleBarView!
    @IBOutlet private weak var aboutView: AboutSectionView!
    @IBOutlet private weak var infoView: InfoGridView!
    @IBOutlet private weak var websiteView: WebsiteRowView!
    @IBOutlet private weak var screenshotsView: ScreenshotsRowView!
    @IBOutlet private weak var contentStack: UIStackView!
    @IBOutlet private weak var storesView: StoresRowView!
    
    // MARK: - Properties
    var gameIdentifier: Int = 0
    private var viewModel: GameDetailViewModelProtocol = GameDetailViewModel()
    private var favoriteButton: UIBarButtonItem!
    private var isFavorite: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        bindViewModel()
        viewModel.loadData(for: gameIdentifier)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem = favoriteButton
        
        checkFavoriteStatus()
    }
    // MARK: - Setup
    private func setupUI() {
        title = "Detail"
        view.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1.0)
        contentStack.setCustomSpacing(12, after: titleView)
        contentStack.setCustomSpacing(12, after: aboutView)
        websiteView.isHidden = true
        storesView.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.populateUI()
        }
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
    }
    // MARK: - Favorite Logic
    private func checkFavoriteStatus() {
        FavoriteService.shared.isFavorite(gameId: gameIdentifier) { [weak self] isFavorite in
            self?.isFavorite = isFavorite
            self?.updateFavoriteButtonAppearance()
        }
    }
    
    private func updateFavoriteButtonAppearance() {
        let iconName = isFavorite ? "heart.fill" : "heart"
        let iconColor: UIColor = isFavorite ? .systemRed : .white
        favoriteButton.image = UIImage(systemName: iconName)
        favoriteButton.tintColor = iconColor
    }
    
    @objc private func didTapFavoriteButton() {
        isFavorite.toggle()
        updateFavoriteButtonAppearance()
        
        if isFavorite {
            FavoriteService.shared.addToFavorites(gameId: gameIdentifier) { [weak self] error in
                if error != nil {
                    print("Error adding to favorites: \(error!.localizedDescription)")
                    self?.isFavorite = false
                    self?.updateFavoriteButtonAppearance()
                    self?.showAlert(title: "Error", message: "Could not add to favorites.")
                }
            }
        } else {
            FavoriteService.shared.removeFromFavorites(gameId: gameIdentifier) { [weak self] error in
                if error != nil {
                    print("Error removing from favorites: \(error!.localizedDescription)")
                    self?.isFavorite = true
                    self?.updateFavoriteButtonAppearance()
                    self?.showAlert(title: "Error", message: "Could not remove from favorites.")
                }
            }
        }
    }
    
    // MARK: - UI Population
    private func populateUI() {
        guard let detail = viewModel.detail else { return }
        heroView.configure(imageURL: URL(string: detail.backgroundImage ?? ""))
        
        titleView.configure(title: detail.name,
                            metaScore: detail.metacritic,
                            releaseDate: detail.releaseDateFormatted)
        titleView.configure(title: detail.name,
                            metaScore: detail.metacritic,
                            releaseDate: detail.releaseDateFormatted)
        
        aboutView.configure(text: detail.descriptionRaw)
        
        let rows: [InfoGridView.Row] = [
            .init(key: "Platforms",    value: detail.platformsText),
            .init(key: "Genres",       value: detail.genresText),
            .init(key: "Developers",   value: detail.developersText),
            .init(key: "Release date", value: detail.releaseDateFormatted),
            .init(key: "Publishers",   value: detail.publishersText),
            .init(key: "Age Rating",   value: detail.ageRatingText),
        ]
        infoView.configure(rows)
        
        if let websiteString = detail.website, !websiteString.isEmpty, let url = URL(string: websiteString) {
            websiteView.isHidden = false
            websiteView.configure(url: url)
        }
        
        screenshotsView.configure(urls: viewModel.screenshotURLs)
        
        storesView.configure(with: viewModel.storeLinks)
    }
}
extension DetailHostViewController {
    static func instantiate(gameId: Int, in storyboardName: String = "Main") -> DetailHostViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: "DetailHostViewController"
        ) as? DetailHostViewController else {
            fatalError("DetailHostViewController not found in \(storyboardName).storyboard")
        }
        controller.gameIdentifier = gameId
        return controller
    }
}
