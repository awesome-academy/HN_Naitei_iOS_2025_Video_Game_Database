import Foundation

struct Tag: Codable {
    let id: Int
    let name: String
    let slug: String?
}

struct ESRBRating: Codable {
    let name: String
}

struct GameDetail: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let metacritic: Int?
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let platforms: [PlatformItem]?
    let developers: [Developer]?
    let publishers: [GamePublisher]?
    let genres: [Genre]?
    let stores: [StoreItemModel]?
    let esrbRating: ESRBRating?
    let tags: [Tag]?
}
