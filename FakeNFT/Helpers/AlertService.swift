import UIKit

protocol AlertServiceProtocol {
    func showChangePhotoURLAlert(with title: String?, message: String?, textFieldPlaceholder: String?, confirmAction: @escaping (String?) -> Void)
    func showAvatarChangeError()
    func showSortAlert(priceSortAction: @escaping () -> Void, ratingSortAction: @escaping () -> Void, titleSortAction: @escaping () -> Void)
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
    
    func showAvatarChangeError() {
        let alertController = UIAlertController(title: "Введен не корретный URL адрес",
                                                message: "Адрес должен быть формата https://example.com/photo.img",
                                                preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        
        alertController.addAction(confirm)
        viewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showSortAlert(priceSortAction: @escaping () -> Void,
                       ratingSortAction: @escaping () -> Void,
                       titleSortAction: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let priceAction = UIAlertAction(title: SortOption.price.description, style: .default) { _ in
            priceSortAction()
        }
        
        let ratingAction = UIAlertAction(title: SortOption.rating.description, style: .default) { _ in
            ratingSortAction()
        }
        
        let titleAction = UIAlertAction(title: SortOption.title.description, style: .default) { _ in
            titleSortAction()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(priceAction)
        alertController.addAction(ratingAction)
        alertController.addAction(titleAction)
        alertController.addAction(cancelAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
