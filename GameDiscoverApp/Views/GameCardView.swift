

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
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
    public func configure(with game: Game) {
        gameNameLabel.text = game.name
        gameImageView.image = nil
        
        if let imageURLString = game.backgroundImage, let url = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.gameImageView.image = UIImage(systemName: "photo.fill")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self?.gameImageView.image = image
                }
            }.resume()
        } else {
            gameImageView.image = UIImage(systemName: "photo.fill")
        }
    }
}
