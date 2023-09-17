//
//  NFTNetworkServiceProtocol.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 17.09.2023.
//

import Foundation

protocol NFTNetworkServiceProtocol: AnyObject {
    var networkClient: NetworkClient { get }

    func loadFavorites(completion: @escaping (Result<NFTFavorites, Error>) -> Void)
    func loadOrders(completion: @escaping (Result<[String], Error>) -> Void)
    func loadNFT(id: String, dispatchGroup: DispatchGroup, completion: @escaping (Result<NFT, Error>) -> Void)
    func updateFavorites(newFavorites: [String])
    func updateOrders(newOrders: [String])
}
