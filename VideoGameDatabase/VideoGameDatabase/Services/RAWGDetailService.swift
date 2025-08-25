import Foundation

protocol GameDetailService {
    func fetchDetail(id: Int, _ completion: @escaping (Result<GameDetail, APIError>) -> Void)
    func fetchScreenshots(id: Int, _ completion: @escaping (Result<[URL], APIError>) -> Void)
    func fetchStores(id: Int, _ completion: @escaping (Result<[GameStoreLink], APIError>) -> Void)
    func fetchSuggested(id: Int, _ completion: @escaping (Result<[Game], APIError>) -> Void)
}

final class RAWGDetailService: GameDetailService {
    
    // MARK: - Properties
    private let client: NetworkingClient
    
    // MARK: - Init
    init(client: NetworkingClient = .shared) {
        self.client = client
    }
    
    // MARK: - Public Methods (Conforming to GameDetailService)
    func fetchDetail(id: Int, _ completion: @escaping (Result<GameDetail, APIError>) -> Void) {
        client.fetch(endpoint: "/games/\(id)", completion: completion)
    }
    
    func fetchScreenshots(id: Int, _ completion: @escaping (Result<[URL], APIError>) -> Void) {
        client.fetch(endpoint: "/games/\(id)/screenshots?page_size=20") { (result: Result<ScreenshotsResponse, APIError>) in
            completion(result.map { $0.results.compactMap { URL(string: $0.image) } })
        }
    }
    
    func fetchStores(id: Int, _ completion: @escaping (Result<[GameStoreLink], APIError>) -> Void) {
        client.fetch(endpoint: "/games/\(id)/stores") { (result: Result<StoresResponse, APIError>) in
            completion(result.map { response in
                response.results.map { wrapper in
                    GameStoreLink(storeID: wrapper.storeId, url: wrapper.url)
                }
            })
        }
    }
    
    func fetchSuggested(id: Int, _ completion: @escaping (Result<[Game], APIError>) -> Void) {
        client.fetch(endpoint: "/games/\(id)/suggested?page_size=20") { (result: Result<GamesResponse, APIError>) in
            completion(result.map { $0.results })
        }
    }
}
