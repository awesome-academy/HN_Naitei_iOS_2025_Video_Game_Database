//
//  RAWGService.swift
//  VideoGameDatabase
//
//  Created by macbook on 20/8/25.
//
import Foundation

final class RAWGService: GamesService {
    private let client: NetworkingClient
    init(client: NetworkingClient = .shared) { self.client = client }
    
    func fetchGenres(pageSize: Int, _ cb: @escaping (Result<[Genre], APIError>) -> Void) {
        client.fetch(endpoint: "/genres?page_size=\(pageSize)") { (r: Result<GenresResponse, APIError>) in
            cb(r.map { $0.results })
        }
    }
    
    func fetchBrowse(genres: Set<String>, filters: FilterOptions, pageSize: Int,
                     _ cb: @escaping (Result<[Game], APIError>) -> Void) {
        let ep = GamesQueryBuilder(filters: filters)
            .pageSize(pageSize).genres(genres).orderingIfNeeded(forSearch: false).build()
        client.fetch(endpoint: ep) { (r: Result<GamesResponse, APIError>) in cb(r.map { $0.results }) }
    }
    
    func search(query: String, genres: Set<String>, filters: FilterOptions, pageSize: Int,
                _ cb: @escaping (Result<(count: Int, exact: [Game], fuzzy: [Game]), APIError>) -> Void) {
        let base = GamesQueryBuilder(filters: filters).pageSize(pageSize).genres(genres).search(query).orderingIfNeeded(forSearch: true)
        let exact = base.searchExact(true).build()
        let fuzzy = base.searchExact(false).build()
        
        let group = DispatchGroup(); var e:[Game]=[]; var f:[Game]=[]; var count=0; var err: APIError?
        group.enter()
        client.fetch(endpoint: exact) { (r: Result<GamesResponse, APIError>) in
            if case .success(let res) = r { e = res.results } else if case .failure(let er) = r { err = er }
            group.leave()
        }
        group.enter()
        client.fetch(endpoint: fuzzy) { (r: Result<GamesResponse, APIError>) in
            if case .success(let res) = r { f = res.results; count = res.count } else if case .failure(let er) = r { err = er }
            group.leave()
        }
        group.notify(queue: .main) {
            if let err = err { cb(.failure(err)); return }
            cb(.success((count, e, f)))
        }
    }
}

