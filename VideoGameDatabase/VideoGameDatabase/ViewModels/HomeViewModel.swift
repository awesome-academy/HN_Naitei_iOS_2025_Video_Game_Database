import Foundation

protocol HomeViewModelProtocol {
    var newLaunchGames: [Game] { get }
    var genres: [Genre] { get }
    var trendingGames: [Game] { get }
    
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchData()
}

final class HomeViewModel: HomeViewModelProtocol {
    
    private(set) var newLaunchGames: [Game] = []
    private(set) var genres: [Genre] = []
    private(set) var trendingGames: [Game] = []
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let networkingClient: NetworkingClient
    
    init(networkingClient: NetworkingClient = .shared) {
        self.networkingClient = networkingClient
    }
    
    func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        fetchNewLaunchGames { group.leave() }
        
        group.enter()
        fetchGenres { group.leave() }
        
        group.notify(queue: .main) { [weak self] in
            self?.fetchTrendingGames()
        }
    }
    
    private func fetchNewLaunchGames(completion: @escaping () -> Void) {
        let endpoint = getNewLaunchEndpoint()
        networkingClient.fetch(endpoint: endpoint) { [weak self] (result: Result<GamesResponse, APIError>) in
            if case .success(let response) = result { self?.newLaunchGames = response.results }
            completion()
        }
    }
    
    private func fetchGenres(completion: @escaping () -> Void) {
        networkingClient.fetch(endpoint: "/genres?page_size=9") { [weak self] (result: Result<GenresResponse, APIError>) in
            if case .success(let response) = result { self?.genres = response.results }
            completion()
        }
    }
    
    private func fetchTrendingGames() {
        let endpoint = getTrendingEndpoint()
        networkingClient.fetch(endpoint: endpoint) { [weak self] (result: Result<GamesResponse, APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.trendingGames = response.results
                self.onDataUpdated?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    private func getNewLaunchEndpoint() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: today) ?? today
        return "/games?dates=\(formatter.string(from: threeMonthsAgo)),\(formatter.string(from: today))&ordering=-released&page_size=5"
    }
    
    private func getTrendingEndpoint() -> String {
        guard let lastYearDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else { return "" }
        let year = Calendar.current.component(.year, from: lastYearDate)
        return "/games?dates=\(year)-01-01,\(year)-12-31&ordering=-added&page_size=50"
    }
}
