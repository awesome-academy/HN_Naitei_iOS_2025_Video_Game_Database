//
//  Genre.swift
//  VideoGameDatabase
//
//  Created by macbook on 12/8/25.
//
import Foundation

struct GenresResponse: Codable {
    let results: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
