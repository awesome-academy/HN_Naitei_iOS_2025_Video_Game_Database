//
//  GameCardView.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import UIKit
import SDWebImage

final class GameCardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Public Methods

    func configure(with game: Game) {
        gameNameLabel.text = game.name
        
        if let imageURLString = game.backgroundImage, let url = URL(string: imageURLString) {
            
            let placeholderImage = UIImage(systemName: "photo.fill")
            gameImageView.contentMode = .scaleAspectFit
            
            gameImageView.sd_setImage(with: url, placeholderImage: placeholderImage) { [weak self] (image, error, cacheType, url) in
                guard let self = self else { return }
                if image != nil {
                    self.gameImageView.contentMode = .scaleAspectFill
                }
            }
        } else {
            gameImageView.image = UIImage(systemName: "photo.fill")
            gameImageView.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GameCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}
