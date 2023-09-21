//
//  NavigationController.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 10.09.2023.
//

import UIKit

final class NavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configureNavigationController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NavigationController: init(coder:) has not been implemented")
    }

    private func configureNavigationController() {
        navigationBar.tintColor = .unBlack
        navigationBar.titleTextAttributes = [
            .font: UIFont.sfBold17,
            .foregroundColor: UIColor.unBlack
        ]
    }
}
