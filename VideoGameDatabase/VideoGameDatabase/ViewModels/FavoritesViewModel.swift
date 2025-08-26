//
//  FavoritesViewModelProtocol.swift
//  VideoGameDatabase
//
//  Created by macbook on 25/8/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FavoritesViewModelProtocol {
    var favoriteGames: [Game] { get }
    var onDataUpdated: (() -> Void)? { get set }
    func fetchFavoriteGames()
    var onError: ((String) -> Void)? { get set } 
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    var onError: ((String) -> Void)?
    
    private(set) var favoriteGames: [Game] = []
    var onDataUpdated: (() -> Void)?
    
    func fetchFavoriteGames() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let collection = Firestore.firestore().collection("users").document(userId).collection("favorites")
        
        collection.getDocuments { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            
            let gameIDs = documents.compactMap { Int($0.documentID) }
            self?.fetchGames(for: gameIDs)
        }
    }
    
    private func fetchGames(for ids: [Int]) {
        let group = DispatchGroup()
        var fetchedGames: [Game] = []
        
        for id in ids {
            group.enter()
            NetworkingClient.shared.fetch(endpoint: "/games/\(id)") { (result: Result<Game, APIError>) in
                if case .success(let game) = result {
                    fetchedGames.append(game)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.favoriteGames = fetchedGames
            self?.onDataUpdated?()
        }
    }
}
