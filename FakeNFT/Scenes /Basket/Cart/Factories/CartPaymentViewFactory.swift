//
//  CartPaymentViewFactory.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import Foundation

struct CartPaymentViewFactory {
    static func create(
        orderId: String,
        currenciesService: CurrenciesServiceProtocol,
        imageLoadingService: ImageLoadingServiceProtocol,
        orderPaymentService: OrderPaymentServiceProtocol
    ) -> CartPaymentViewController {
        
        // TODO: - Доработать facrory в 3/3 части.
    return CartPaymentViewController()
    }
}
