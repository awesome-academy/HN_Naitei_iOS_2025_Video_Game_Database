// Favorites/CoreDataFavoritesStore.swift
import CoreData

final class CoreDataFavoritesStore: FavoritesStore {
    static let shared = CoreDataFavoritesStore()
    private init() {}
    private let stack = CoreDataStack.shared

    // MARK: - Read
    func isFavorite(gameId: Int) -> Bool {
        let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fr.fetchLimit = 1
        fr.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
        do { return try stack.viewContext.count(for: fr) > 0 } catch { return false }
    }

    func fetchAll() -> [Game] {
        let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(key: "addedDate", ascending: false)]
        do {
            let items = try stack.viewContext.fetch(fr)
            return items.map { $0.asGame() }
        } catch {
            return []
        }
    }

    // MARK: - Write
    func addToFavorites(game: Game, completion: @escaping (Error?) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.perform {
            // upsert nhờ unique constraint gameId
            let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fr.fetchLimit = 1
            fr.predicate = NSPredicate(format: "gameId == %lld", Int64(game.id))
            let obj = (try? ctx.fetch(fr).first) ?? FavoriteGame(context: ctx)
            obj.gameId = Int64(game.id)
            obj.name = game.name
            obj.backgroundImage = game.backgroundImage
            obj.metacritic = Int16(game.metacritic ?? 0)
            obj.addedDate = Date()
            do { try ctx.save(); completion(nil) } catch { completion(error) }
        }
    }

    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        let ctx = stack.newBackgroundContext()
        ctx.perform {
            let fr: NSFetchRequest<FavoriteGame> = FavoriteGame.fetchRequest()
            fr.predicate = NSPredicate(format: "gameId == %lld", Int64(gameId))
            do {
                try ctx.fetch(fr).forEach { ctx.delete($0) }
                try ctx.save()
                completion(nil)
            } catch { completion(error) }
        }
    }
}

// MARK: - Mapping CoreData <-> Game
private extension FavoriteGame {
    func asGame() -> Game {
        Game(
            id: Int(gameId),
            name: name ?? "",
            backgroundImage: backgroundImage,
            metacritic: metacritic == 0 ? nil : Int(metacritic),
            genres: nil
        )
    }
}
