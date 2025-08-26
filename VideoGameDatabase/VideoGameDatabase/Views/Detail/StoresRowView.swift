import UIKit

final class StoresRowView: NibView {
    
    @IBOutlet private weak var storesStackView: UIStackView!
    
    func configure(with links: [GameStoreLink]) {
        storesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if links.isEmpty {
            self.isHidden = true
            return
        }
        
        self.isHidden = false
        
        for link in links {
            let button = StoreButton()
            button.configure(with: link)
            button.addAction(UIAction { _ in
                if let url = URL(string: link.url) {
                    UIApplication.shared.open(url)
                }
            }, for: .touchUpInside)
            storesStackView.addArrangedSubview(button)
        }
    }
}
