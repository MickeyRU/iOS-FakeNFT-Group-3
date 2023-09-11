//
//  CartViewFactory.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 10.09.2023.
//

import Foundation

struct CartViewFactory {
    static func create() -> NavigationController {
        let networkClient = DefaultNetworkClient()
        let networkRequestSender = NetworkRequestSender(networkClient: networkClient)

        let orderService = OrderService(networkRequestSender: networkRequestSender)
        let nftService = NFTNetworkServiceImpl(networkClient: networkClient)
        let imageLoadingService = ImageLoadingService()

        let cartViewInteractor = CartViewInteractor(
            nftService: nftService,
            orderService: orderService,
            imageLoadingService: imageLoadingService
        )
        let orderSorter = CartOrderSorter()

        let viewModel = CartViewModel(intercator: cartViewInteractor, orderSorter: orderSorter)
        let tableViewHelper = CartTableViewHelper()

        let currenciesService = CurrenciesService(networkRequestSender: networkRequestSender)
        let router = CartViewRouter(
            currenciesService: currenciesService,
            imageLoadingService: imageLoadingService,
            orderPaymentService: orderService
        )

        let viewController = BasketViewController(
            viewModel: viewModel,
            tableViewHelper: tableViewHelper,
            router: router
        )

        let navigationController = NavigationController(rootViewController: viewController)
        return navigationController
    }
}
