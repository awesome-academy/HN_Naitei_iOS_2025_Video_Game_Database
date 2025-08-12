//
//  Platform.swift
//  VideoGameDatabase
//
//  Created by macbook on 12/8/25.
//
import Foundation

struct PlatformItem: Codable {
    let platform: Platform
}

struct Platform: Codable {
    let id: Int
    let name: String
    let slug: String
}
