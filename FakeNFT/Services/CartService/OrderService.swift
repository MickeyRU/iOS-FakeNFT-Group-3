//
//  OrderService.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 07.09.2023.
//

import Foundation

public protocol OrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping ResultHandler<Order>)
    func changeOrder(id: String, nftIds: [String], completion: @escaping ResultHandler<Order>)
}

public protocol OrderPaymentServiceProtocol {
    func purchase(orderId: String, currencyId: String, completion: @escaping ResultHandler<PurchaseResult>)
}

final class OrderService {
    private let networkRequestSender: NetworkRequestSenderProtocol

    private var fetchingTask: DefaultNetworkTask?
    private var changingTask: DefaultNetworkTask?
    private var purchasingTask: DefaultNetworkTask?

    init(networkRequestSender: NetworkRequestSenderProtocol) {
        self.networkRequestSender = networkRequestSender
    }
}

// MARK: - OrderServiceProtocol

extension OrderService: OrderServiceProtocol {
    func fetchOrder(id: String, completion: @escaping ResultHandler<Order>) {}
    
    func changeOrder(id: String, nftIds: [String], completion: @escaping ResultHandler<Order>) {}
}

// MARK: - OrderPaymentServiceProtocol

extension OrderService: OrderPaymentServiceProtocol {
    func purchase(orderId: String, currencyId: String, completion: @escaping ResultHandler<PurchaseResult>) {}
}
