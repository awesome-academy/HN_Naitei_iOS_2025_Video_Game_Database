import UIKit

final class MetacriticTagView: UIView {
    private let scoreLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = .systemFont(ofSize: 14, weight: .bold)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) { super.init(frame: frame); commonInit() }
    required init?(coder: NSCoder) { super.init(coder: coder); commonInit() }

    private func commonInit() {
        layer.cornerRadius = 5
        clipsToBounds = true
        addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override var intrinsicContentSize: CGSize {
        let s = scoreLabel.intrinsicContentSize
        return CGSize(width: s.width + 16, height: s.height + 8)
    }

    func configure(with score: Int?) {
        guard let score, score > 0 else { isHidden = true; return }
        isHidden = false
        scoreLabel.text = String(score)
        backgroundColor = score >= 75 ? .systemGreen : (score >= 50 ? .systemOrange : .systemRed)
    }
}
