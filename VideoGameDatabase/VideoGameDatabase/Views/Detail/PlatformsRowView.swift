import UIKit

final class PlatformsRowView: NibView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Platforms"
        valueLabel.numberOfLines = 0
    }

    func configure(text: String) {
        valueLabel.text = text
    }
}
