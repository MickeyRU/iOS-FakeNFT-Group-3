import UIKit

extension UIViewController {
    // Расширение для использования в ToastService
    func showToast(message: String, duration: Double = 2.0) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = UIColor.black
            alert.view.alpha = 0.6
            alert.view.layer.cornerRadius = 15
            
            present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: true)
            }
        }
    
    func setupCustomBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backButtonImage"),
                                         style: .plain, target: self,
                                         action: #selector(self.customBackAction))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
