//
//  Game.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import Foundation

struct GamesResponse: Codable {
    let results: [Game]
}

struct Game: Codable {
    let id: Int
    let name: String
    let backgroundImage: String?
    let metacritic: Int?
    let genres: [Genre]?
}

struct GameDetail: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let metacritic: Int?
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let platforms: [PlatformWrapper]?
    let developers: [Developer]?
    let publishers: [Publisher]?
    let genres: [Genre]?
    let stores: [StoreWrapper]?
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct PlatformWrapper: Codable {
    let platform: Platform
}

struct Platform: Codable {
    let id: Int
    let name: String
    let slug: String
}

struct Developer: Codable {
    let id: Int
    let name: String
}

struct Publisher: Codable {
    let id: Int
    let name: String
}

struct StoreWrapper: Codable {
    let store: Store
}

struct Store: Codable {
    let id: Int
    let name: String
    let domain: String?
}
