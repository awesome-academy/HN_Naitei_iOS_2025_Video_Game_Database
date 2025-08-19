//
//  GenreCollectionViewCell.swift
//  VideoGameDatabase
//
//  Created by macbook on 15/8/25.
//

import UIKit

final class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var genreNameLabel: UILabel!
    
    static let reuseIdentifier = "GenreCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with genre: Genre) {
        genreNameLabel.text = genre.name
    }
}
