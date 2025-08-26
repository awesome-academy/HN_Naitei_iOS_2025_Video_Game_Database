//
//  MovieModels.swift
//  VideoGameDatabase
//
//  Created by macbook on 25/8/25.
//

import Foundation
struct MoviesResponse: Codable {
    struct MovieItem: Codable { let data: MovieData }
    struct MovieData: Codable { let max: String? }
    let results: [MovieItem]
}
