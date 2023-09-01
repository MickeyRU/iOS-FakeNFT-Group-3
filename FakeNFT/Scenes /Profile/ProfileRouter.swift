import UIKit

protocol ProfileRouting {
    func routeToEditingViewController(with profile: UserProfileModel, delegate: EditingViewControllerProtocol)
}

class ProfileRouter: ProfileRouting {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToEditingViewController(with profile: UserProfileModel, delegate: EditingViewControllerProtocol) {
        let editingViewController = EditingViewController(userProfile: profile, delegate: delegate)
        viewController?.present(editingViewController, animated: true)
    }
}
