//
//  ViewController.swift
//  VideoGameDatabase
//
//  Created by macbook on 6/8/25.
//

import UIKit

class ViewController: UIViewController {
    //test thử networking
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gamesEndpoint = "/games?genres=action"
        
        print("Bắt đầu fetch dữ liệu...")
        
        NetworkingClient.shared.fetch(endpoint: gamesEndpoint) { (result: Result<GamesResponse, APIError>) in
            switch result {
            case .success(let gamesResponse):
                print("Fetch thành công! Lấy được \(gamesResponse.results.count) game.")
                for game in gamesResponse.results.prefix(3) {
                    print("- \(game.name)")
                }
                
            case .failure(let error):
                print("Fetch thất bại với lỗi: \(error)")
            }
        }
    }
}

