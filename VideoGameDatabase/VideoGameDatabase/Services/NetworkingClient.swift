//
//  NetworkingClient.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import Foundation

final class NetworkingClient {
    static let shared = NetworkingClient()
    
    private let apiKey = "32f88c2bfb2c4abab74d0914c61b78e7"
    private let baseURL = "https://api.rawg.io/api"
    
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetch<T: Codable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endpoint)") else {
            return completion(.failure(.invalidURL))
        }
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "key", value: apiKey))
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return DispatchQueue.main.async { completion(.failure(.requestFailed(error))) }
            }
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode),
                  let data = data else {
                return DispatchQueue.main.async { completion(.failure(.invalidData)) }
            }
            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decoded)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError(error))) }
            }
        }.resume()
    }
}
