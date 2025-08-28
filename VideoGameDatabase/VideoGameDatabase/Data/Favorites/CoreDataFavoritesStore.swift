import CoreData

final class CoreDataFavoritesStore: FavoritesStore {
    static let shared = CoreDataFavoritesStore(); private init() {}
    private let stack = CoreDataStack.shared

    // MARK: Read
    func isFavorite(gameId: Int) -> Bool {
        let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fr.fetchLimit = 1
        fr.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
        return (try? stack.viewContext.count(for: fr)) ?? 0 > 0
    }

    func fetchAll() -> [Game] {
        let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        let items = (try? stack.viewContext.fetch(fr)) ?? []
        return items.map { $0.asGame() }
    }

    // MARK: Write
    func addToFavorites(game: Game, completion: @escaping (Error?) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.perform {
            let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fr.fetchLimit = 1
            fr.predicate = NSPredicate(format: "gameId == %lld", Int64(game.id))
            let entity = (try? ctx.fetch(fr).first) ?? FavoriteGame(context: ctx)
            entity.gameId = Int64(game.id)
            entity.name = game.name
            entity.backgroundImage = game.backgroundImage
            entity.metacritic = Int16(game.metacritic ?? 0)
            entity.addedDate = Date()
            do { try ctx.save(); DispatchQueue.main.async { completion(nil) } }
            catch { DispatchQueue.main.async { completion(error) } }
        }
    }

    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.perform {
            let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fr.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
            do { try ctx.fetch(fr).forEach { ctx.delete($0) }; try ctx.save(); DispatchQueue.main.async { completion(nil) } }
            catch { DispatchQueue.main.async { completion(error) } }
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
