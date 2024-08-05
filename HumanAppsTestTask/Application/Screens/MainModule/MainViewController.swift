
import UIKit
import SnapKit
import PhotosUI
import RxCocoa

final class MainViewController: ViewController {
    
    private let mainImageView = MainImageView()
    
    private let photoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.watermelon.color
        button.setTitle(L10n.Main.clickMe, for: .normal)
        button.titleLabel?.font = FontFamily.Lufga.medium.font(size: 17)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private lazy var galleryPickerController: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        return picker
    }()
    
    var viewModel: MainViewModel!
    
    override func arrangeSubviews() {
        super.arrangeSubviews()
        
        view.addSubviews(photoButton, mainImageView)
    }
    
    override func setupViewConstraints() {
        super.setupViewConstraints()
        
        photoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        photoButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.requestPhotoAuthorization()
            }).disposed(by: disposeBag)
        
        mainImageView.rx.saveButtonTapped.asDriver()
            .drive(onNext: { [weak self] in
                self?.mainImageView.acceptCropDataModel()
            }).disposed(by: disposeBag)
        
        mainImageView.rx.cropImageRelay.asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] model in
                self?.viewModel.saveCroppedImage(model: model)
            }).disposed(by: disposeBag)
        
        viewModel.photoCompletionRelay.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isSaved in
                self?.showCompletionAlert(message: isSaved ? L10n.AlertCompletion.successfully :
                                                             L10n.AlertCompletion.failed)
                self?.changeView(isShowImage: false)
            }).disposed(by: disposeBag)
        
        mainImageView.rx.segmentedDidTapped.asDriver()
            .drive(onNext: { [weak self] index in
                self?.viewModel.applyBlackAndWhiteFilter(index: index)
            }).disposed(by: disposeBag)
        
        viewModel.blackAndWhiteImageRelay.asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] image in
                self?.mainImageView.applyImage(image: image)
            }).disposed(by: disposeBag)
    }
    
    private func changeView(isShowImage: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.mainImageView.alpha = isShowImage ? 1 : 0
            self.photoButton.alpha = isShowImage ? 0 : 1
        }
    }
}

private extension MainViewController {
    
    func requestPhotoAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] authStatus in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.present(self.galleryPickerController, animated: true)
                case .denied, .restricted:
                    if self.viewModel.selectPhotoTapped {
                        self.showPhotoPermissionAlert()
                    }
                    self.viewModel.setSelectPhoto()
                default:
                    break
                }
            }
        }
    }
    
    func showPhotoPermissionAlert() {
        let alert = UIAlertController(title: L10n.AlertPermission.photos,
                                      message: L10n.AlertPermission.photoAccess,
                                      preferredStyle: .alert)
        
        let alertOkAction = UIAlertAction(title: L10n.AlertPermission.goToSettings,
                                          style: .default) { [weak self] _ in
            self?.viewModel.goToSettings()
        }
        let alertCancelAction = UIAlertAction(title: L10n.AlertPermission.cancel, style: .cancel)
        alert.addAction(alertCancelAction)
        alert.addAction(alertOkAction)
        self.present(alert, animated: true)
    }
    
    func showCompletionAlert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.AlertCompletion.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let image = object as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self?.mainImageView.image = image
                    self?.viewModel.currentPhoto = image
                    self?.changeView(isShowImage: true)
                }
            }
        }
    }
}
