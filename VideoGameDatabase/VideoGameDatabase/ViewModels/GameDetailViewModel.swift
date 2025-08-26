import Foundation

protocol GameDetailViewModelProtocol {
    var onDataUpdated: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var detail: GameDetail? { get }
    var screenshotURLs: [URL] { get }
    var storeLinks: [GameStoreLink] { get }
    func loadData(for gameId: Int)
}

final class GameDetailViewModel: GameDetailViewModelProtocol {
    private let service: GameDetailService
    init(service: GameDetailService = RAWGDetailService()) { self.service = service }

    private(set) var detail: GameDetail?
    private(set) var screenshotURLs: [URL] = []
    private(set) var storeLinks: [GameStoreLink] = []

    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    func loadData(for gameId: Int) {
        let group = DispatchGroup()
        var fetchError: Error?

        group.enter()
        service.fetchDetail(id: gameId) { [weak self] result in
            if case .success(let d) = result { self?.detail = d } else { fetchError = (try? result.get()) as? Error }
            group.leave()
        }

        group.enter()
        service.fetchScreenshots(id: gameId) { [weak self] result in
            if case .success(let urls) = result { self?.screenshotURLs = urls }
            group.leave()
        }

        group.enter()
        service.fetchStores(id: gameId) { [weak self] result in
            if case .success(let links) = result { self?.storeLinks = links }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            if let e = fetchError { self.onError?(e.localizedDescription) }
            else { self.onDataUpdated?() }
        }
    }
}
