//
//  APIError.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}
