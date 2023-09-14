import UIKit

protocol ToastServiceProtocol {
    func showToast(message: String, duration: Double)
}

final class ToastService: ToastServiceProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showToast(message: String, duration: Double = 2.0) {
        viewController?.showToast(message: message, duration: duration)
    }
}

