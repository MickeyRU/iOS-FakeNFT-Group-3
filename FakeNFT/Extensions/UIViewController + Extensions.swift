import UIKit

extension UIViewController {

    func setupCustomBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backButtonImage"), style: .plain, target: self, action: #selector(self.customBackAction))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
