import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = generateViewControllers()
        generateTabBarIconsWithName(for: viewControllers)
    }
<<<<<<< HEAD:FakeNFT/MainViewController/MainTabBarController.swift
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToShowCatalogNotification()
    }
=======
>>>>>>> e1c4d710e5fbdde5e2cce4a796b9304b19827012:FakeNFT/MainTabBarController.swift

    private func generateViewControllers() -> [UIViewController] {
        let profileViewController = ProfileViewController()
        let catalogViewController = CatalogViewController()
        let basketViewController = CartViewFactory.create()
        let statisticsViewController = StatisticsViewController()
        return [profileViewController, catalogViewController, basketViewController, statisticsViewController]
    }

    private func generateTabBarIconsWithName(for viewControllers: [UIViewController]?) {
        guard let viewControllers = viewControllers else { return }

        let profileImage = UIImage(systemName: "person.crop.circle.fill")
        let catalogImage = UIImage(systemName: "square.stack.fill")
        let basketImage = UIImage(systemName: "basket.fill")
        let statisticsImage = UIImage(systemName: "flag.2.crossed.fill")
        let imagesArray = [profileImage, catalogImage, basketImage, statisticsImage]

        let profileName = NSLocalizedString("profile", comment: "")
        let catalogName = NSLocalizedString("catalog", comment: "")
        let basketName = NSLocalizedString("basket", comment: "")
        let statisticsName = NSLocalizedString("statistic", comment: "")
        let nameArray = [profileName, catalogName, basketName, statisticsName]

        for (index, viewController) in viewControllers.enumerated() {
            viewController.tabBarItem.image = imagesArray[index]
            viewController.tabBarItem.title = nameArray[index]
        }
    }
}

// MARK: - NotificationCenter

private extension MainTabBarController {
    func subscribeToShowCatalogNotification() {
        NotificationCenterWrapper.shared.subscribeToNotification(type: .showCatalog) { [weak self] _ in
            guard let self else { return }
            let catalogViewController = 1
            let cartNavigationControllerIndex = 2
            let cartController = self.viewControllers?[cartNavigationControllerIndex] as? UINavigationController
            guard let cartNavigationController = cartController else { return }
            
            cartNavigationController.popToRootViewController(animated: false)
            self.selectedIndex = catalogViewController
        }
    }
}
