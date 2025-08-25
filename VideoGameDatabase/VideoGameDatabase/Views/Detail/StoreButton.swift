import UIKit

final class StoreButton: UIButton {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with link: GameStoreLink) {
        let storeName = getStoreName(from: link.storeID)
        
        var updatedConfig = self.configuration
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        updatedConfig?.attributedTitle = AttributedString(storeName, attributes: titleContainer)
        
        self.configuration = updatedConfig
    }
    
    // MARK: - Private Methods
    
    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(white: 0.2, alpha: 1.0)
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        self.configuration = config
        self.contentHorizontalAlignment = .leading
    }
    
    private func getStoreName(from storeId: Int) -> String {
        switch storeId {
        case 1:  return "Steam"
        case 3:  return "PlayStation Store"
        case 2:  return "Xbox Store"
        case 4:  return "App Store"
        case 5:  return "GOG"
        case 6:  return "Nintendo Store"
        case 8:  return "Google Play"
        case 11: return "Epic Games"
        default: return "Visit Store"
        }
    }
}
