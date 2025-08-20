import Foundation

protocol DiscoverViewModelProtocol {
    var chips: [Genre] { get }
    var selectedSlugs: Set<String> { get }
    var browseGames: [Game] { get }
    var resultGames: [Game] { get }
    var headerText: String { get }
    var currentFilters: FilterOptions { get }
    
    var onUpdateBrowse: (() -> Void)? { get set }
    var onUpdateResults: (() -> Void)? { get set }
    
    func loadInitial()
    func toggleGenre(slug: String)
    func search(_ q: String)
    func apply(_ f: FilterOptions)
    func clearFilters()
}

final class DiscoverViewModel: DiscoverViewModelProtocol {
    private let service: GamesService
    init(service: GamesService = RAWGService()) { self.service = service }
    
    private(set) var chips: [Genre] = []
    private(set) var selectedSlugs: Set<String> = []
    private(set) var browseGames: [Game] = []
    private(set) var resultGames: [Game] = []
    private(set) var headerText: String = ""
    private(set) var currentFilters: FilterOptions = .default
    private var lastQuery = ""
    
    var onUpdateBrowse: (() -> Void)?
    var onUpdateResults: (() -> Void)?
    
    func loadInitial() {
        service.fetchGenres(pageSize: 30) { [weak self] r in
            if case .success(let g) = r { self?.chips = g
                self?.onUpdateBrowse?()
            }
        }
        fetchBrowse()
    }
    
    func toggleGenre(slug: String) {
        if selectedSlugs.contains(slug) { selectedSlugs.remove(slug) } else { selectedSlugs.insert(slug) }
        fetchBrowse()
    }
    
    func search(_ q: String) {
        lastQuery = q
        service.search(query: q, genres: selectedSlugs, filters: currentFilters, pageSize: 30) { [weak self] r in
            guard let self = self else { return }
            if case .success(let res) = r {
                let exactIDs = Set(res.exact.map { $0.id })
                let filtered = res.fuzzy.filter { !exactIDs.contains($0.id) }
                let qLower = q.lowercased()
                let starts = filtered.filter { $0.name.lowercased().hasPrefix(qLower) && !$0.name.lowercased().elementsEqual(qLower) }
                let others = filtered.filter { !( $0.name.lowercased().hasPrefix(qLower) && !$0.name.lowercased().elementsEqual(qLower) ) }
                self.resultGames = res.exact + starts + others
                self.headerText = "Found \(res.count) items"
                self.onUpdateResults?()
            }
        }
    }
    
    func apply(_ f: FilterOptions) {
        currentFilters = f
        if lastQuery.isEmpty { fetchBrowse() } else { search(lastQuery) }
    }
    
    func clearFilters() { apply(.default) }
    
    private func fetchBrowse() {
        service.fetchBrowse(genres: selectedSlugs, filters: currentFilters, pageSize: 20) { [weak self] r in
            if case .success(let games) = r { self?.browseGames = games; self?.onUpdateBrowse?() }
        }
    }
}
