import UIKit
import SDWebImage

final class HeroHeaderView: NibView {
    @IBOutlet private weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 16
        layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    func configure(imageURL: URL?) {
        imageView.sd_setImage(with: imageURL,
                              placeholderImage: UIImage(systemName: "photo"))
    }
}
