//
//  UIAlertController+Extensions.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//

import UIKit

extension UIAlertController {
    static func sortingAlertController(
        onChoosingSortingTrait: @escaping ActionCallback<CartOrderSorter.SortingTrait>
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: "sort_alert_title".localized,
            message: nil,
            preferredStyle: .actionSheet
        )

        let sortByPriceAction = UIAlertAction(
            title: "sort_alert_price_action".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.price) }

        let sortByRatingAction = UIAlertAction(
            title: "sort_alert_rating_action".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.rating) }

        let sortByNameAction = UIAlertAction(
            title: "sort_alert_name_action".localized,
            style: .default
        ) { _ in onChoosingSortingTrait(.name) }

        let closeAction = UIAlertAction(
            title: "sort_alert_close_action".localized,
            style: .cancel
        ) { _ in }

        [sortByPriceAction, sortByRatingAction, sortByNameAction, closeAction].forEach {
            alertController.addAction($0)
        }

        return alertController
    }

    static func alert(for error: Error) -> UIAlertController {
        let alertController = UIAlertController(
            title: "default _error_title".localized,
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        return alertController
    }
}

