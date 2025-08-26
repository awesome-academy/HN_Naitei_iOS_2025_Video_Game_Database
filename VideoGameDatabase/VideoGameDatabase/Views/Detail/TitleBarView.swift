import UIKit

final class TitleBarView: NibView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var metaView: UIView!
    @IBOutlet private weak var releaseLabel: UILabel!

    private lazy var metaLabel: UILabel = {
        let metalabel = UILabel()
        metalabel.textColor = .white
        metalabel.font = .systemFont(ofSize: 14, weight: .bold)
        metalabel.textAlignment = .center
        metalabel.translatesAutoresizingMaskIntoConstraints = false
        return  metalabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupMetaBadge()
    }

    private func setupMetaBadge() {
        metaView.layer.cornerRadius = 5
        metaView.clipsToBounds = true
        metaView.addSubview(metaLabel)
        NSLayoutConstraint.activate([
            metaLabel.topAnchor.constraint(equalTo: metaView.topAnchor, constant: 4),
            metaLabel.bottomAnchor.constraint(equalTo: metaView.bottomAnchor, constant: -4),
            metaLabel.leadingAnchor.constraint(equalTo: metaView.leadingAnchor, constant: 8),
            metaLabel.trailingAnchor.constraint(equalTo: metaView.trailingAnchor, constant: -8)
        ])
        metaView.setContentHuggingPriority(.required, for: .horizontal)
        metaView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(title: String, metaScore: Int?, releaseDate: String?) {
        titleLabel.text = title
        releaseLabel.text = releaseDate

        if let score = metaScore, score > 0 {
            metaView.isHidden = false
            metaLabel.text = String(score)
            metaView.backgroundColor = score >= 75 ? .systemGreen : (score >= 50 ? .systemOrange : .systemRed)
        } else {
            metaView.isHidden = true
        }
    }
}
