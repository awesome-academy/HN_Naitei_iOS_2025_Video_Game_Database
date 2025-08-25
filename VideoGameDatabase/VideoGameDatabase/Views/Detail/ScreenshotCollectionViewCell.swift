//
//  ScreenshotCollectionViewCell.swift
//  VideoGameDatabase
//
//  Created by macbook on 21/8/25.
//

import UIKit
import SDWebImage

final class ScreenshotCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ScreenshotCollectionViewCell"
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(url: URL?) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
    }
}
