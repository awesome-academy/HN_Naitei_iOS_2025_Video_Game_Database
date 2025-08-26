import Foundation

struct GameStoreLink: Codable, Hashable {
    let storeID: Int
    let url: String
}

struct StoresResponse: Codable {
    let results: [StoreWrapper]
    
    struct StoreWrapper: Codable {
        let storeId: Int
        let url: String
    }
}
