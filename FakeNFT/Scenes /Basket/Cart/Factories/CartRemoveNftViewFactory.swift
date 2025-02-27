//
//  CartRemoveNftViewFactory.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import UIKit.UIImage

struct CartRemoveNftViewFactory {
    static func create(
        nftImage: UIImage?,
        onChoosingRemoveNft: @escaping (CartRemoveNftViewController.RemoveNftFlow) -> Void
    ) -> CartRemoveNftViewController {
        let removeNftViewController = CartRemoveNftViewController(nftImage: nftImage)
        removeNftViewController.onChoosingRemoveNft = onChoosingRemoveNft

        removeNftViewController.modalPresentationStyle = .overFullScreen
        removeNftViewController.modalTransitionStyle = .crossDissolve

        return removeNftViewController
    }
}
