import UIKit

class MetacriticTagView: UIView {

    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            scoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            scoreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
    }
    
    public func configure(with score: Int?) {
        guard let score = score else {
            self.isHidden = true
            return
        }
        
        self.isHidden = false
        scoreLabel.text = String(score)
        
        if score >= 75 {
            self.backgroundColor = .systemGreen
        } else if score >= 50 {
            self.backgroundColor = .systemYellow
        } else {
            self.backgroundColor = .systemRed
        }
    }
}
