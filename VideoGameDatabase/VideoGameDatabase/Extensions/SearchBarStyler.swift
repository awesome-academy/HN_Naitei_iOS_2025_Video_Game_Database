import UIKit

enum SearchBarStyler {
  static func applyDark(_ sb: UISearchBar) {
    sb.searchBarStyle = .minimal
    sb.searchTextField.backgroundColor = .black
    sb.searchTextField.textColor = .white
    sb.searchTextField.layer.borderColor = UIColor.lightGray.cgColor
    sb.searchTextField.layer.borderWidth = 1
    sb.searchTextField.layer.cornerRadius = 8
    if let iv = sb.searchTextField.leftView as? UIImageView {
      iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
      iv.tintColor = .lightGray
    }
  }
}
