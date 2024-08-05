
import UIKit
import RxSwift

open class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    open var isNavigationBarHidden: Bool {
        return true
    }
    
    open var backgroundColor: UIColor {
        return .white
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: false)
        
        setupStyle()
        arrangeSubviews()
        setupViewConstraints()
        setupNavigationItems()
        bind()
    }

    open func setupNavigationItems() {}

    open func setupStyle() {}

    open func arrangeSubviews() {}

    open func setupViewConstraints() {}

    open func bind() {}

}
