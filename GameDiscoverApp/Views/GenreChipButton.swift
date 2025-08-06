
import UIKit

class GenreChipButton: UIButton {

    override init(frame: CGRect) {
           super.init(frame: frame)
           setupButton()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupButton()
       }
       
       private func setupButton() {
           var config = UIButton.Configuration.filled()
           config.baseBackgroundColor = .systemGray5
           config.baseForegroundColor = .label
           config.cornerStyle = .capsule
           config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
           
           self.configuration = config
           self.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
       }
       
       public func setTitle(_ title: String) {
           self.setTitle(title, for: .normal)
       }

}
