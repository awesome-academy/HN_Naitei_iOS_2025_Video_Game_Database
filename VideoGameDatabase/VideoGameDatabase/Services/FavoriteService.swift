//
//  FavoriteService.swift
//  VideoGameDatabase
//
//  Created by macbook on 25/8/25.
//


// Services/FavoriteService.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FavoriteService {
    static let shared = FavoriteService()
    private init() {}
    
    private var db = Firestore.firestore()
    
    private func currentUserCollection() -> CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        return db.collection("users").document(userId).collection("favorites")
    }
    
    private enum FavoriteError: LocalizedError {
        case notSignedIn
        var errorDescription: String? { "User is not signed in." }
    }
    
    func isFavorite(gameId: Int, completion: @escaping (Bool) -> Void) {
        guard let collection = currentUserCollection() else { return completion(false) }
        collection.document(String(gameId)).getDocument { document, _ in
            completion(document?.exists ?? false)
        }
    }
    
    func addToFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        guard let collection = currentUserCollection() else { return completion(FavoriteError.notSignedIn) }
        collection.document(String(gameId)).setData(["addedDate": Timestamp(date: Date())], completion: completion)
    }
    
    func removeFromFavorites(gameId: Int, completion: @escaping (Error?) -> Void) {
        guard let collection = currentUserCollection() else { return completion(FavoriteError.notSignedIn) }
        collection.document(String(gameId)).delete(completion: completion)
    }
}
