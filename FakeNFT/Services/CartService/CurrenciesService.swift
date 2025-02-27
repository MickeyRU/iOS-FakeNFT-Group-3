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

// MARK: - CurrenciesServiceProtocol

extension CurrenciesService: CurrenciesServiceProtocol {
    func fetchCurrencies(completion: @escaping ResultHandler<CurrenciesResult>) {
        guard Thread.isMainThread else { return }
        guard !self.fetchingTask.isRunning else { return }
        
        let request = CurrenciesRequest()
        let task = self.networkRequestSender.send(
            request: request,
            task: self.fetchingTask,
            type: CurrenciesResult.self,
            completion: completion
        )
        
        self.fetchingTask = task
    }
}
