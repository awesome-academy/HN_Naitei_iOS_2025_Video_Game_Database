import UIKit

final class GameGridDataSource: NSObject,
                                UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var games: [Game] = []
    var onGameSelected: ((Game) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? GameCardCollectionViewCell else {
            assertionFailure("GameCardCollectionViewCell dequeue failed")
            return UICollectionViewCell()
        }
        cell.configure(with: games[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onGameSelected?(games[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sidePadding: CGFloat = 16
        let interItemSpacing: CGFloat = 10
        let cellWidth = floor((collectionView.bounds.width - sidePadding * 2 - interItemSpacing) / 2)
        return CGSize(width: cellWidth, height: cellWidth * 1.25)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
