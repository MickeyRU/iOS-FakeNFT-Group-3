//
//  NFTNetworkService.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 17.09.2023.
//

import Foundation

final class NFTNetworkService: NFTNetworkServiceProtocol {

    private(set) var networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadFavorites(completion: @escaping (Result<NFTFavorites, Error>) -> Void) {
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1"))
        networkClient.send(request: request, type: NFTFavorites.self) { [weak self] result in
            switch result {
            case let .success(favorites):
                completion(.success(favorites))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func loadOrders(completion: @escaping (Result<[String], Error>) -> Void) {
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/orders/1"))
        networkClient.send(request: request, type: NFTOrders.self) { [weak self] result in
            switch result {
            case let .success(orders):
                completion(.success(orders.nfts))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func loadNFT(id: String, dispatchGroup: DispatchGroup, completion: @escaping (Result<NFT, Error>) -> Void) {
        dispatchGroup.enter()
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/nft/\(id)"))
        networkClient.send(request: request, type: NFT.self) { [weak self] result in
            switch result {
            case let .success(nft):
                completion(.success(nft))
                dispatchGroup.leave()
            case let .failure(error):
                completion(.failure(error))
                dispatchGroup.leave()
            }
        }
    }

    func updateFavorites(newFavorites: [String]) {
        let request = UpdateRequest(
            endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1"),
            dto: NFTFavorites(likes: newFavorites))

        networkClient.send(request: request) { result in
            switch result {
            case .success:
                print("success")
            case .failure:
                print("Unable to update favorites")
            }
        }
    }

    func updateOrders(newOrders: [String]) {
        let request = UpdateRequest(
            endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/orders/1"),
            dto: NFTOrders(nfts: newOrders))

        networkClient.send(request: request) { result in
            switch result {
            case .success:
                print("success")
            case .failure:
                print("Unable to ypdate cart")
            }
        }

    }
}
