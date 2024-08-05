
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
        bind()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    open func setupStyle() {}

    open func arrangeSubviews() {}

    open func setupViewConstraints() {}
    
    open func bind() {}
}

