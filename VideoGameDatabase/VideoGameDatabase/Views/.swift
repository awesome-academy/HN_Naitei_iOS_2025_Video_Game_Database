//
//  BannerCollectionViewCell 2.swift
//  VideoGameDatabase
//
//  Created by macbook on 18/8/25.
//


import UIKit
import SDWebImage

final class BannerCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerCollectionViewCell"

    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!

    private let gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true

        // Gradient from transparent to 80% black
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }

    func configure(with game: Game) {
        titleLabel.text = game.name
        if let s = game.backgroundImage, let url = URL(string: s) {
            bannerImageView.sd_setImage(with: url,
                                        placeholderImage: UIImage(systemName: "photo.fill"))
        } else {
            bannerImageView.image = UIImage(systemName: "photo.fill")
        }
    }
}
