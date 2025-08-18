//
//  GameCardCollectionViewCell.swift
//  VideoGameDatabase
//
//  Created by macbook on 15/8/25.
//

import UIKit

final class GameCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var gameCardView: GameCardView!
    
    static let reuseIdentifier = "GameCardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with game: Game) {
        gameCardView.configure(with: game)
    }
}
