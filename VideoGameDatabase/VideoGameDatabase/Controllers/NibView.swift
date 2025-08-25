import UIKit

class NibView: UIView {
    @IBOutlet private(set) var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        embedFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        embedFromNib()
    }
    
    private func embedFromNib() {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        guard let contentView = contentView else {
            assertionFailure("⚠️ Kéo nối `contentView` của \(nibName) vào root view trong xib.")
            return
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
}
