
import UIKit

open class View: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
        bind()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStyle() {}
    func arrangeSubviews() {}
    func setupViewConstraints() {}
    func bind() {}
}
