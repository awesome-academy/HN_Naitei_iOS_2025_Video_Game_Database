import UIKit

final class InfoGridView: NibView {
    @IBOutlet private weak var hStack: UIStackView!
    @IBOutlet private weak var leftColumn: UIStackView!
    @IBOutlet private weak var rightColumn: UIStackView!
    
    struct Row { let key: String; let value: String }
    
    
    func configure(_ rows: [Row]) {
        leftColumn.arrangedSubviews.forEach { $0.removeFromSuperview() }
        rightColumn.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        self.isHidden = rows.isEmpty
        guard !rows.isEmpty else { return }
        
        for (index, row) in rows.enumerated() {
            if index < (rows.count + 1) / 2 {
                leftColumn.addArrangedSubview(makeRow(row))
            } else {
                rightColumn.addArrangedSubview(makeRow(row))
            }
        }
    }
    
    private func makeRow(_ r: Row) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        
        let keyLabel = UILabel()
        keyLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        keyLabel.textColor = .lightGray
        keyLabel.text = r.key
        
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 15)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        valueLabel.text = r.value
        
        stack.addArrangedSubview(keyLabel)
        stack.addArrangedSubview(valueLabel)
        return stack
    }
}
