protocol FavoritesStore {
    func isFavorite(gameId: Int) -> Bool
    func addToFavorites(game: Game, completion: @escaping (Error?) -> Void)
    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void)
    func fetchAll() -> [Game]
}
