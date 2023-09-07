//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 07.09.2023.
//

import Foundation

public protocol CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>)
}

final class CurrenciesService {
    private let networkRequestSender: NetworkRequestSenderProtocol
    
    private var fetchingTask: DefaultNetworkTask?

    init(networkRequestSender: NetworkRequestSenderProtocol) {
        self.networkRequestSender = networkRequestSender
    }
}
