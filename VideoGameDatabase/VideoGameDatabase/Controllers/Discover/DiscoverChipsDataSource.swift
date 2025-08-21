import UIKit

final class DiscoverChipsDataSource: NSObject,
                                     UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var genres: [Genre] = []
    var selectedSlugs = Set<String>()
    var onToggle: ((Genre, Bool) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genre = genres[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiscoverGenreChipCell.reuseIdentifier,
            for: indexPath
        ) as? DiscoverGenreChipCell else {
            assertionFailure("DiscoverGenreChipCell dequeue failed")
            return UICollectionViewCell()
        }
        cell.configure(title: genre.name, isSelected: selectedSlugs.contains(genre.slug))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.item]
        let newState: Bool
        if selectedSlugs.contains(genre.slug) {
            selectedSlugs.remove(genre.slug)
            newState = false
        } else {
            selectedSlugs.insert(genre.slug)
            newState = true
        }
        onToggle?(genre, newState)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = genres[indexPath.item].name as NSString
        let titleWidth = ceil(
            title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width
        )
        return CGSize(width: titleWidth + 32, height: 36)
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
}
