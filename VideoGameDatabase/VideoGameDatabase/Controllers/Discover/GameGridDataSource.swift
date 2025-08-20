import UIKit

final class GameGridDataSource: NSObject,
                                UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var games: [Game] = []
    var onSelect: ((Game) -> Void)?
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { games.count }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(
            withReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! GameCardCollectionViewCell
        cell.configure(with: games[indexPath.item])
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(games[indexPath.item])
    }
    
    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side: CGFloat = 16, gap: CGFloat = 10
        let w = floor((cv.bounds.width - side * 2 - gap) / 2)
        return CGSize(width: w, height: w * 1.25)
    }
    
    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
    
    func collectionView(_ cv: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 10 }
}
