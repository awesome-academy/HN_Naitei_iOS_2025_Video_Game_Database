//
//  ScreenshotsRowView.swift
//  VideoGameDatabase
//
//  Created by macbook on 22/8/25.
//

import UIKit
final class ScreenshotsRowView: NibView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var items: [URL] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Screenshot"
        collectionView.register(UINib(nibName: "ScreenshotCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: ScreenshotCollectionViewCell.reuseIdentifier)
        if let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.scrollDirection = .horizontal
            flow.minimumLineSpacing = 12
            flow.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        collectionView.dataSource = self; collectionView.delegate = self
    }
    
    func configure(urls: [URL]) {
        items = urls
        isHidden = items.isEmpty
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScreenshotCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! ScreenshotCollectionViewCell
        cell.configure(url: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 16 / 9, height: height)
    }
}
