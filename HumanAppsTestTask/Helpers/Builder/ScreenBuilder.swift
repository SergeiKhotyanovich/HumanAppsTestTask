
import Foundation

final class ScreenBuilder {
    
    static let applicationCacheDataManager = ApplicationCacheDataManager()
    static let photoCroppingManager = PhotoCroppingManager()
    static let blackAndWhiteManager = BlackAndWhiteManager()

    static func produceMainScreen() -> MainViewController {
        let viewController = MainViewController()
        
        let viewModel = MainViewModel(applicationCacheDataManager: applicationCacheDataManager, photoCroppingManager: photoCroppingManager, blackAndWhiteManager: blackAndWhiteManager)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    static func produceSettingsScreen() -> SettingsViewController {
        let viewController = SettingsViewController()
        
        let viewModel = SettingsViewModel()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
