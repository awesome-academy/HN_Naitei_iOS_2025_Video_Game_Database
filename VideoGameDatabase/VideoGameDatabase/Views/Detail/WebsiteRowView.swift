//
//  WebsiteRowView.swift
//  VideoGameDatabase
//
//  Created by macbook on 22/8/25.
//

import UIKit
final class WebsiteRowView: NibView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Website"
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
    }
    
    func configure(url: URL?) {
        guard let url else {
            isHidden = true
            return
        }
        let text = url.absoluteString
        let att = NSAttributedString(string: text,
                                     attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                  .foregroundColor: UIColor.link,
                                                  .font: UIFont.systemFont(ofSize: 14)])
        button.setAttributedTitle(att, for: .normal)
        button.accessibilityValue = text
    }
    
    @IBAction private func openSite(_ s: UIButton) {
        guard let v = s.accessibilityValue, let url = URL(string: v) else { return }
        UIApplication.shared.open(url)
    }
}
