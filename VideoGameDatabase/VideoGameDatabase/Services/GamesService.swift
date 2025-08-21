//
//  GamesService.swift
//  VideoGameDatabase
//
//  Created by macbook on 20/8/25.
//
import Foundation

protocol GamesService {
    func fetchGenres(pageSize: Int, _ completion: @escaping (Result<[Genre], APIError>) -> Void)
    func fetchBrowse(genres: Set<String>, filters: FilterOptions, pageSize: Int,
                     _ completion: @escaping (Result<[Game], APIError>) -> Void)
    func search(query: String, genres: Set<String>, filters: FilterOptions, pageSize: Int,
                _ completion: @escaping (Result<(count: Int, exact: [Game], fuzzy: [Game]), APIError>) -> Void)
}
