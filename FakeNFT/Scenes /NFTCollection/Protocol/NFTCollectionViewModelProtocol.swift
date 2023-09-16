//
//  NFTCollectionViewModelProtocol.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 09.09.2023.
//

import Foundation

protocol NFTCollectionViewModelProtocol: AnyObject {
    var nfts: [NFT] { get }
    var nftsObserve: NFTCollectionObservable<[NFT]> { get }

    var name: String? { get }
    var nameObserve: NFTCollectionObservable<String?> { get }

    var author: String? { get }
    var authorObserve: NFTCollectionObservable<String?> { get }

    var description: String? { get }
    var descriptionObserve: NFTCollectionObservable<String?> { get }

    var imageURL: URL? { get }
    var imageURLObserve: NFTCollectionObservable<URL?> { get }

    var isLoaded: Bool { get }
    var isLoadedObserve: NFTCollectionObservable<Bool> { get }

    var favorites: [String] { get }
    var favoritesObserve: NFTCollectionObservable<[String]> { get }

    var orders: [String] { get }
    var ordersObserve: NFTCollectionObservable<[String]> { get }

    var numberOfRows: Int { get }

    func initialize()
    func nft(at indexPath: IndexPath) -> NFT?
    func getCellViewModel(for nft: NFT) -> NFTCellViewModel
    func favoriteButtonTapped(at indexPath: IndexPath)
    func cartButtonTapped(at indexPath: IndexPath)
}
