import Foundation

protocol FavoritesViewModelProtocol {
    var favoriteGames: [Game] { get }
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    func fetchFavoriteGames()
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    private(set) var favoriteGames: [Game] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchFavoriteGames() {
        favoriteGames = FavoriteService.shared.allFavorites()
        onDataUpdated?()
    }
}
