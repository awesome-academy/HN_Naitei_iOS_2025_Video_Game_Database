import UIKit

final class GenreChipButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func configure(with title: String) {
        var cfg = configuration ?? .filled()
        var attrs = AttributeContainer()
        attrs.font = .systemFont(ofSize: 14, weight: .medium)
        cfg.attributedTitle = AttributedString(title, attributes: attrs)
        configuration = cfg
    }
    
    private func setupButton() {
        var cfg = UIButton.Configuration.filled()
        cfg.cornerStyle = .capsule
        cfg.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration = cfg
        
        configurationUpdateHandler = { btn in
            var c = btn.configuration ?? .filled()
            if btn.isSelected {
                c.baseBackgroundColor = .systemYellow
                c.baseForegroundColor = .black
            } else {
                c.baseBackgroundColor = .systemGray5
                c.baseForegroundColor = .label
            }
            btn.configuration = c
        }
    }
}
