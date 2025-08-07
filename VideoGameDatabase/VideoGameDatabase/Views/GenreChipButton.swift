import UIKit

class GenreChipButton: UIButton {

    private var buttonConfiguration: UIButton.Configuration = .filled()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        buttonConfiguration.baseBackgroundColor = .systemGray4
        buttonConfiguration.baseForegroundColor = .label
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 14, weight: .medium)
        buttonConfiguration.attributedTitle = AttributedString(self.title(for: .normal) ?? "", attributes: titleContainer)
        
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
        
        buttonConfiguration.cornerStyle = .capsule
        
        self.configuration = buttonConfiguration
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        var titleContainer = AttributeContainer()
        titleContainer.font = .systemFont(ofSize: 14, weight: .medium)
        buttonConfiguration.attributedTitle = AttributedString(title ?? "", attributes: titleContainer)
        
        self.configuration = buttonConfiguration
        
        super.setTitle(title, for: state)
    }
}
