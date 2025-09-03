import Foundation

private let RAWG_API_KEY = "32f88c2bfb2c4abab74d0914c61b78e7"

private struct TrailersResponse: Decodable {
    struct Movie: Decodable {
        struct DataField: Decodable {
            let max: String?
            let _480: String?
            enum CodingKeys: String, CodingKey {
                case max
                case _480 = "480"
            }
        }
        let data: DataField
    }
    let results: [Movie]
}

private struct GameDetailClipResponse: Decodable {
    struct Clip: Decodable {
        let clip: String?
        let clips: [String: String]?
    }
    let clip: Clip?
}

enum RAWGTrailersAPI {
    static func fetchStreamURL(gameId: Int, completion: @escaping (Result<URL, Error>) -> Void) {
        fetchFromMovies(gameId: gameId) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure:
                fetchFromGameClip(gameId: gameId, completion: completion)
            }
        }
    }
    
    private static func fetchFromMovies(gameId: Int, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let requestURL = URL(string: "https://api.rawg.io/api/games/\(gameId)/movies?key=\(RAWG_API_KEY)") else {
            return completion(.failure(NSError(domain: "RAWG.movies.url", code: 0)))
        }
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            do {
                let response = try JSONDecoder().decode(TrailersResponse.self, from: data ?? Data())
                for movie in response.results {
                    let candidateString = movie.data.max ?? movie.data._480
                    if let normalizedURL = normalize(urlString: candidateString),
                       isPlayableStream(normalizedURL) {
                        return completion(.success(normalizedURL))
                    }
                }
                completion(.failure(NSError(domain: "RAWG.movies.empty", code: 404)))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    
    private static func fetchFromGameClip(gameId: Int, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let requestURL = URL(string: "https://api.rawg.io/api/games/\(gameId)?key=\(RAWG_API_KEY)") else {
            return completion(.failure(NSError(domain: "RAWG.clip.url", code: 0)))
        }
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            do {
                let response = try JSONDecoder().decode(GameDetailClipResponse.self, from: data ?? Data())
                let candidateString =
                response.clip?.clips?["full"] ??
                response.clip?.clip ??
                response.clip?.clips?["640"] ??
                response.clip?.clips?["480"] ??
                response.clip?.clips?["320"]
                
                guard let normalizedURL = normalize(urlString: candidateString),
                      isPlayableStream(normalizedURL) else {
                    return completion(.failure(NSError(domain: "RAWG.clip.notfound", code: 404)))
                }
                completion(.success(normalizedURL))
            } catch { completion(.failure(error)) }
        }.resume()
    }
    
    private static func normalize(urlString: String?) -> URL? {
        guard var string = urlString, !string.isEmpty else { return nil }
        if string.hasPrefix("//") { string = "https:" + string }
        if string.hasPrefix("http://") { string = string.replacingOccurrences(of: "http://", with: "https://") }
        return URL(string: string)
    }
    
    private static func isPlayableStream(_ url: URL) -> Bool {
        let lowercased = url.absoluteString.lowercased()
        return lowercased.hasSuffix(".mp4") || lowercased.contains(".m3u8")
    }
}
