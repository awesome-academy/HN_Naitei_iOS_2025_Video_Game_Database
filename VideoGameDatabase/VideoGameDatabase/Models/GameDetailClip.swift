import Foundation

struct GameDetailClipResponse: Decodable {
    let clip: GameClip?
}
struct GameClip: Decodable {
    let clip: String?
    let clips: [String: String]?
}
