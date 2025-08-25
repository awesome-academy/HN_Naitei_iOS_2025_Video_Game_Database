import Foundation

struct PlatformItem: Codable {
    let platform: PlatformRef?
    let name: String?

    struct PlatformRef: Codable {
        let id: Int?
        let name: String
    }
}

struct Platform: Codable {
    let id: Int
    let name: String
    let slug: String
}
