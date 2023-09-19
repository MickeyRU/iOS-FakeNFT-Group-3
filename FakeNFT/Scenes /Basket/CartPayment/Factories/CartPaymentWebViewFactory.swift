//
//  CartPaymentWebViewFactory.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 11.09.2023.
//

import Foundation

struct CartPaymentWebViewFactory {
    static func create(url: URL) -> CartPaymentWebViewController {
        let request = URLRequest(url: url)
        let webViewController = CartPaymentWebViewController(request: request)
        return webViewController
    }
}
