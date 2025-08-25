import UIKit

final class TitleBarView: NibView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var metaView: MetacriticTagView!
    @IBOutlet private weak var releaseLabel: UILabel!
    
    func configure(title: String, metaScore: Int?, releaseDate: String?) {
        titleLabel.text = title
        metaView.configure(with: metaScore)
        releaseLabel.text = releaseDate
    }
}
