//
//  StoreItemModel.swift
//  VideoGameDatabase
//
//  Created by macbook on 12/8/25.
//

import Foundation

struct StoreItemModel: Codable {
    let store: StoreDetail
}

struct StoreDetail: Codable {
    let id: Int
    let name: String
    let domain: String?
}
