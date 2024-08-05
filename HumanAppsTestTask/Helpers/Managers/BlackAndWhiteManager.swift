
import UIKit
import RxRelay
import RxSwift

final class BlackAndWhiteManager: NSObject {
    
    fileprivate var photoRelay = PublishRelay<UIImage?>()
    
    var currentPhoto: UIImage?
    
     func applyBlackAndWhiteFilter(index: Int) {
        photoRelay.accept(index == 0 ? currentPhoto : applyBlackAndWhiteFilter())
    }
}

private extension BlackAndWhiteManager {
    
    func applyBlackAndWhiteFilter() -> UIImage? {
        guard let currentPhoto else { return nil }
        
        let ciImage = CIImage(image: currentPhoto)
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let outputImage = filter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

extension Reactive where Base == BlackAndWhiteManager {

    var blackAndWhiteImageRelay: Observable<UIImage?> {
        base.photoRelay.asObservable()
    }
}
