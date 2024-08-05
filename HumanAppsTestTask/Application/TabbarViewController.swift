
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        setConfigurations()
        configureAppearance()
    }
    
    private func setConfigurations() {
        let mainViewController = UINavigationController(rootViewController: ScreenBuilder.produceMainScreen())
        let settingsViewController = UINavigationController(rootViewController: ScreenBuilder.produceSettingsScreen())
        
        mainViewController.tabBarItem = UITabBarItem(title: L10n.Tabbar.main,
                                                     image: Asset.Images.Tabbar.main.image,
                                                     tag: 0)
        settingsViewController.tabBarItem = UITabBarItem(title: L10n.Tabbar.settings,
                                                         image: Asset.Images.Tabbar.settings.image,
                                                         tag: 1)
        
        setViewControllers([mainViewController, settingsViewController], animated: true)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .white
    }
}
