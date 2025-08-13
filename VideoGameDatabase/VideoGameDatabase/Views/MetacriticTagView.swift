//
//  MetacriticTagView.swift
//  VideoGameDatabase
//
//  Created by macbook on 7/8/25.
//

import UIKit

class MetacriticTagView: UIView {
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 5
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    public func configure(with score: Int?) {
        guard let score = score, score > 0 else {
            self.isHidden = true
            return
        }
        
        self.isHidden = false
        scoreLabel.text = String(score)
        
        if score >= 75 {
            backgroundColor = .systemGreen
        } else if score >= 50 {
            backgroundColor = .systemOrange
        } else {
            backgroundColor = .systemRed
        }
    }
}
