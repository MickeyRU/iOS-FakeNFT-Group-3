import UIKit
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .black
        ProgressHUD.colorBackground = .lightGray
        UINavigationBar.appearance().tintColor = .unBlack
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: Constants.defaultConfiguration, sessionRole: connectingSceneSession.role)
    }
}
