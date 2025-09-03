import Foundation

struct TrailerMoviesResponse: Decodable {
    let results: [TrailerMovie]
}
struct TrailerMovie: Decodable {
    let data: TrailerData
}
struct TrailerData: Decodable {
    let max: String?
    let _480: String?
    enum CodingKeys: String, CodingKey {
        case max
        case _480 = "480"
    }
}
