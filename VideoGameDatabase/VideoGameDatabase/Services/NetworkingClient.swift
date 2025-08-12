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
            completion(.failure(.invalidURL))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let decodedObject = try self.decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        task.resume()
    }
}
