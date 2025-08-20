import UIKit

final class DiscoverChipsDataSource: NSObject,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var genres: [Genre] = []
    var selectedSlugs = Set<String>()
    var onToggle: ((Genre, Bool) -> Void)?

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { genres.count }

        func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let g = genres[indexPath.item]
            let cell = cv.dequeueReusableCell(
                withReuseIdentifier: DiscoverGenreChipCell.reuseIdentifier,
                for: indexPath
            ) as! DiscoverGenreChipCell
            cell.configure(title: g.name, selected: selectedSlugs.contains(g.slug))
            return cell
        }

        func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let g = genres[indexPath.item]
            let newState: Bool
            if selectedSlugs.contains(g.slug) { selectedSlugs.remove(g.slug); newState = false }
            else { selectedSlugs.insert(g.slug); newState = true }
            onToggle?(g, newState)
            cv.reloadItems(at: [indexPath])
        }

        func collectionView(_ cv: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let title = genres[indexPath.item].name as NSString
            let w = ceil(title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width)
            return CGSize(width: w + 32, height: 36)
        }

        func collectionView(_ cv: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }

        func collectionView(_ cv: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat { 10 }
    }
