import UIKit

final class GenreChipButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String) {
        var newConfig = self.configuration ?? UIButton.Configuration.filled()
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 14, weight: .medium)
        
        newConfig.attributedTitle = AttributedString(title, attributes: titleContainer)
        
        self.configuration = newConfig
    }
    
    // MARK: - Private Methods
    
    private func setupButton() {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .label
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        config.cornerStyle = .capsule
        
        self.configuration = config
    }
}
