import UIKit

final class TrendingDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var games: [Game] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCardCollectionViewCell.reuseIdentifier, for: indexPath) as! GameCardCollectionViewCell
        cell.configure(with: games[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sidePadding: CGFloat = 10
        let interItemSpacing: CGFloat = 10
        let availableWidth = collectionView.bounds.width - sidePadding * 2 - interItemSpacing
        let width = availableWidth / 2
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }
}
