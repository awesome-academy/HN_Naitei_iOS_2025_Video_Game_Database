//
//  Game.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import Foundation

struct GamesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
    
}

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let metacritic: Int?
    let genres: [Genre]?
}

