import Foundation

final class FavoriteService {
    static let shared = FavoriteService(); private init() {}
    
    private let store: FavoritesStore = CoreDataFavoritesStore.shared
    
    func isFavorite(gameId: Int, completion: @escaping (Bool) -> Void) {
        completion(store.isFavorite(gameId: gameId))
    }
    
    func addToFavorites(game: Game, completion: @escaping (Error?) -> Void) {
        store.addToFavorites(game: game, completion: completion)
    }
    
    func addToFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        completion(NSError(domain: "FavoriteService", code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Please use addToFavorites(game:) with at least name and image."]))
    }
    
    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        store.removeFromFavorites(gameId: gameId, completion: completion)
    }
    
    func allFavorites() -> [Game] { store.fetchAll() }
}
