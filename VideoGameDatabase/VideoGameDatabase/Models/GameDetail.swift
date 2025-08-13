//
//  GameDetail.swift
//  VideoGameDatabase
//
//  Created by macbook on 12/8/25.
//

import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let descriptionRaw: String?
    let metacritic: Int?
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let platforms: [PlatformItem]?
    let developers: [Developer]?
    let publishers: [GamePublisher]?
    let genres: [Genre]?
    let stores: [StoreItemModel]?
}
