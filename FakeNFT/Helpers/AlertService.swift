import UIKit

protocol AlertServiceProtocol {
    func showChangePhotoURLAlert(with title: String?, message: String?, textFieldPlaceholder: String?, confirmAction: @escaping (String?) -> Void)
}

class AlertService: AlertServiceProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showChangePhotoURLAlert(with title: String?, message: String?, textFieldPlaceholder: String?, confirmAction: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
        }
        
        let confirmAction = UIAlertAction(title: "Подтвердить", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            confirmAction(text)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorMessage(with title: String?,
                          message: String?,
                          retryHandler: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let reloadAction = UIAlertAction(title: "Попробовать еще раз", style: .default) { _ in
            retryHandler?()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(reloadAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
