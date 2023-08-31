import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = generateViewControllers()
        generateTabBarIconsWithName(for: viewControllers)
    }

    private func generateViewControllers() -> [UIViewController] {
        let profileViewController = ProfileViewController()
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
        let basketViewController = BasketViewController()
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
