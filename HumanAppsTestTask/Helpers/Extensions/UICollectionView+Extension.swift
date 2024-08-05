
import UIKit

public extension UICollectionView {

    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeue<Cell: UICollectionViewCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to dequeue reusable cell with reuse identifier: \(cellType.reuseIdentifier), at index path: \(indexPath)")
        }

        return cell
    }
}

public extension UICollectionReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

