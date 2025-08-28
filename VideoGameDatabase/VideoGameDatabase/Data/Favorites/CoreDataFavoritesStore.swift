import CoreData

final class CoreDataFavoritesStore: FavoritesStore {
    static let shared = CoreDataFavoritesStore(); private init() {}
    private let stack = CoreDataStack.shared
    
    // MARK: Read
    func isFavorite(gameId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
        return (try? stack.viewContext.count(for: fetchRequest)) ?? 0 > 0
    }
    
    func fetchAll() -> [Game] {
        let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        let items = (try? stack.viewContext.fetch(fetchRequest)) ?? []
        return items.map { $0.asGame() }
    }
    
    // MARK: Write
    func addToFavorites(game: Game, completion: @escaping (Error?) -> Void) {
        let context = stack.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "gameId == %lld", Int64(game.id))
            let entity = (try? context.fetch(fetchRequest).first) ?? FavoriteGame(context: context)
            entity.gameId = Int64(game.id)
            entity.name = game.name
            entity.backgroundImage = game.backgroundImage
            entity.metacritic = Int16(game.metacritic ?? 0)
            entity.addedDate = Date()
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        let context = stack.newBackgroundContext()
        context.perform {
            let fetchRequest: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
            do {
                try context.fetch(fetchRequest).forEach {
                    context.delete($0)
                }
                try context.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}

private extension FavoriteGame {
    func asGame() -> Game {
        Game(id: Int(gameId),
             name: name ?? "",
             backgroundImage: backgroundImage,
             metacritic: metacritic == 0 ? nil : Int(metacritic),
             genres: nil)
    }
}
