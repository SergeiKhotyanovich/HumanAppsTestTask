
import UIKit

public class ApplicationCacheDataManager {

    var selectPhotoTapped: Bool {
        return UserDefaults.standard.bool(forKey: Keys.selectPhotoTapped)
    }
    
    public init() {}

    func setSelectPhotoTapped() {
        UserDefaults.standard.set(true, forKey: Keys.selectPhotoTapped)
    }
}

extension ApplicationCacheDataManager {
    enum Keys {
        static let selectPhotoTapped = "selectPhotoTapped"
    }
}
