//
//  AboutSectionView.swift
//  VideoGameDatabase
//
//  Created by macbook on 22/8/25.
//

import UIKit

final class AboutSectionView: NibView {
    @IBOutlet private weak var aboutTitle: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    @IBOutlet private weak var moreButton: UIButton!
    
    private var isCollapsed = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        aboutTitle.text = "About"
        bodyLabel.numberOfLines = 15
        moreButton.setTitle("Read more", for: .normal)
    }
    
    func configure(text: String?) {
        bodyLabel.text = text
        moreButton.isHidden = (bodyLabel.maxNumberOfLines <= 15)
    }
    
    @IBAction private func toggleDescriptionExpansion(_ sender: UIButton) {
        isCollapsed.toggle()
        
        bodyLabel.numberOfLines = isCollapsed ? 15 : 0
        let buttonTitle = isCollapsed ? "Read more" : "Show less"
        moreButton.setTitle(buttonTitle, for: .normal)
    }
}

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
