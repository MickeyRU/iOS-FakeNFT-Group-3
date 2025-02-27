//
//  AlertService.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 11.09.2023.
//

import UIKit

struct AlertActionModel {
    let title: String
    let style: UIAlertAction.Style
    let handler: ((String?) -> Void)?
}

struct AlertModel {
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let actions: [AlertActionModel]
    let textFieldPlaceholder: String?
}

protocol AlertServiceProtocol {
    func initVC(viewController: UIViewController)
    func showAlert(model: AlertModel)
}

final class AlertService: AlertServiceProtocol {
    private weak var viewController: UIViewController?

    func initVC(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showAlert(model: AlertModel) {
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: model.style)

        if let placeholder = model.textFieldPlaceholder {
            alertController.addTextField { textField in
                textField.placeholder = placeholder
            }
        }

        model.actions.forEach { actionModel in
            let action = UIAlertAction(title: actionModel.title, style: actionModel.style) { _ in
                if let textField = alertController.textFields?.first {
                    actionModel.handler?(textField.text)
                } else {
                    actionModel.handler?(nil)
                }
            }
            alertController.addAction(action)
        }

        viewController?.present(alertController, animated: true, completion: nil)
    }
}
