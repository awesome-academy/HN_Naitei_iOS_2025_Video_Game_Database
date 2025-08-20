//
//  DiscoverGenreChipCell.swift
//  VideoGameDatabase
//
//  Created by macbook on 19/8/25.
//

import UIKit

class DiscoverGenreChipCell: UICollectionViewCell {
    static let reuseIdentifier = "DiscoverGenreChipCell"
    @IBOutlet private weak var chipButton: GenreChipButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chipButton.isUserInteractionEnabled = false   
        isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            chipButton.isSelected = isSelected
            chipButton.setNeedsUpdateConfiguration()
        }
    }
    
    func configure(title: String, selected: Bool) {
        chipButton.configure(with: title)
        chipButton.isSelected = selected
        chipButton.setNeedsUpdateConfiguration()
    }
}
