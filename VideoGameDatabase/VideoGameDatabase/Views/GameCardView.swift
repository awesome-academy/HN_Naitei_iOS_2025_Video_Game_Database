//
//  GameCardView.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import UIKit

class GameCardView: UIView {
    
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
    
    private func commonInit() {
        Bundle.main.loadNibNamed("GameCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    public func configure(with game: Game) {
        gameNameLabel.text = game.name
        
        gameImageView.image = UIImage(systemName: "photo")
        
        if let imageURLString = game.backgroundImage, let url = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.gameImageView.image = image
                }
            }.resume()
        }
    }
}
