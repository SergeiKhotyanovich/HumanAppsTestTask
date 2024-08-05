
import UIKit
import RxRelay
import RxSwift

final class MainViewModel {
    
    let disposeBag = DisposeBag()
    
    private let applicationCacheDataManager: ApplicationCacheDataManager
    private let photoCroppingManager: PhotoCroppingManager
    private let blackAndWhiteManager: BlackAndWhiteManager
    
    private(set) var photoCompletionRelay = PublishRelay<Bool>()
    private(set) var blackAndWhiteImageRelay = PublishRelay<UIImage?>()
    
    init(applicationCacheDataManager: ApplicationCacheDataManager, photoCroppingManager: PhotoCroppingManager, blackAndWhiteManager: BlackAndWhiteManager) {
        self.photoCroppingManager = photoCroppingManager
        self.blackAndWhiteManager = blackAndWhiteManager
        self.applicationCacheDataManager = applicationCacheDataManager
        
        observeBlackAndWhiteImage()
    }
    
    var selectPhotoTapped: Bool {
        return applicationCacheDataManager.selectPhotoTapped
    }
    
    var currentPhoto: UIImage? {
        didSet {
            guard let currentPhoto else { return }
            
            blackAndWhiteManager.currentPhoto = currentPhoto
        }
    }
    
    func setSelectPhoto() {
        applicationCacheDataManager.setSelectPhotoTapped()
    }
    
    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func saveCroppedImage(model: CropDataModel) {
        photoCroppingManager.saveCroppedImage(model: model) { [weak self] isSaved in 
            self?.photoCompletionRelay.accept(isSaved)
        }
    }
    
    func applyBlackAndWhiteFilter(index: Int) {
        blackAndWhiteManager.applyBlackAndWhiteFilter(index: index)
    }
}

private extension MainViewModel {
    
    func observeBlackAndWhiteImage() {
        blackAndWhiteManager.rx.blackAndWhiteImageRelay.asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] image in
                self?.blackAndWhiteImageRelay.accept(image)
            }).disposed(by: disposeBag)
    }
}
