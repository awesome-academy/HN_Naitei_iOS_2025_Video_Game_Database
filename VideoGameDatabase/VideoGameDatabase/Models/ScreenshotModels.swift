//
//  ScreenshotModels.swift
//  VideoGameDatabase
//
//  Created by macbook on 25/8/25.
//

import Foundation
struct ScreenshotsResponse: Codable {
    struct Screenshot: Codable { let image: String }
    let results: [Screenshot]
}
