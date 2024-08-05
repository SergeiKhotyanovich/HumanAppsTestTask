
import UIKit

final class PhotoCroppingManager {
    
    func saveCroppedImage(model: CropDataModel, completion: @escaping (Bool) -> Void) {
        croppedImage(model: model, completion: completion)
    }
}

private extension PhotoCroppingManager {
    func croppedImage(model: CropDataModel, completion: @escaping (Bool) -> Void) {
        let cropRect = getImageCropRect(model: model)
        
        if let croppedCGImage = model.image.cgImage?.cropping(to: cropRect) {
            let croppedImage = UIImage(cgImage: croppedCGImage)
            
            UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func getImageCropRect(model: CropDataModel) -> CGRect {
        let imageScale: CGFloat = min(model.image.size.width/model.cropAreaWight,                                                                model.image.size.height/model.cropAreaHeight)
        
        let zoomFactor = 1 / model.zoomScale
        let x = (model.contentOffsetX + model.cropAreaFrameX) * zoomFactor * imageScale
        let y = (model.contentOffsetY + model.cropAreaFrameY) * zoomFactor * imageScale
        let width = model.cropAreaWight * zoomFactor * imageScale
        let height = model.cropAreaHeight * zoomFactor * imageScale
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
