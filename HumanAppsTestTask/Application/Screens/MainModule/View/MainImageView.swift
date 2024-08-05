
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class MainImageView: View {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let cropAreaView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = Asset.Colors.yellow.color.cgColor
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private var imageHeightConstraint: Constraint!
    private var imageWidthConstraint: Constraint!
    
    fileprivate let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Main.save, for: .normal)
        button.backgroundColor = Asset.Colors.watermelon.color
        button.titleLabel?.font = FontFamily.Lufga.medium.font(size: 17)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Original", "B&W"])
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    fileprivate var cropImageRelay = PublishRelay<CropDataModel?>()
    
    var image: UIImage? {
        didSet {
            guard let image else { return }
            
            maskCropArea()
            setImageToCrop(image: image)
        }
    }
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        addSubviews(scrollView, cropAreaView, shadowView, saveButton, segmentedControl)
        scrollView.addSubview(mainImageView)
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        alpha = 0
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cropAreaView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(132)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        mainImageView.snp.makeConstraints { make in
            imageWidthConstraint = make.width.equalTo(100).constraint
            imageHeightConstraint = make.height.equalTo(100).constraint
            make.horizontalEdges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(64)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func maskCropArea() {
        let outerPath = UIBezierPath(rect: shadowView.frame)
        let rectPath = UIBezierPath(rect: cropAreaView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(rectPath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = outerPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = Asset.Colors.black.color.withAlphaComponent(0.6).cgColor
        shadowView.layer.addSublayer(maskLayer)
    }
    
    private func setImageToCrop(image: UIImage) {
        mainImageView.image = image
        
        let scale = max(cropAreaView.frame.size.width / image.size.width,
                        cropAreaView.frame.size.height / image.size.height)
        
        let verticalInset = (scrollView.frame.height - cropAreaView.frame.height) / 2
        let horizontalInset = (scrollView.frame.width - cropAreaView.frame.width) / 2
        
        imageWidthConstraint.update(offset: image.size.width * scale)
        imageHeightConstraint.update(offset: image.size.height * scale)
        
        segmentedControl.selectedSegmentIndex = 0
        
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset,
                                               left: horizontalInset,
                                               bottom: verticalInset,
                                               right: horizontalInset)
        
        scrollView.contentOffset = CGPoint(x: ((image.size.width * scale) - scrollView.frame.width) / 2,
                                           y: ((image.size.height * scale) - scrollView.frame.height) / 2)
        self.layoutIfNeeded()
    }
    
    func acceptCropDataModel() {
        guard let image = mainImageView.image else { return }
        
        let model = CropDataModel(image: image,
                                  cropAreaFrameX: cropAreaView.frame.origin.x,
                                  cropAreaFrameY: cropAreaView.frame.origin.y,
                                  cropAreaWight: cropAreaView.frame.size.width,
                                  cropAreaHeight: cropAreaView.frame.size.height,
                                  contentOffsetX: scrollView.contentOffset.x,
                                  contentOffsetY: scrollView.contentOffset.y,
                                  zoomScale: scrollView.zoomScale)
        
        cropImageRelay.accept(model)
    }
    
    func applyImage(image: UIImage) {
        mainImageView.image = image
    }

}

extension MainImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainImageView
    }
}

extension Reactive where Base == MainImageView {
    
    var saveButtonTapped: Driver<Void> {
        base.saveButton.rx.tap.asDriver()
    }
    
    var cropImageRelay: Observable<CropDataModel?> {
        base.cropImageRelay.asObservable()
    }
    
    var segmentedDidTapped: Driver<Int> {
        base.segmentedControl.rx.selectedSegmentIndex.asDriver()
    }
}


