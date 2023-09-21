//
//  NFTCollectionViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 07.09.2023.
//

import Foundation

final class NFTCollectionViewModel: NFTCollectionViewModelProtocol {
    @NFTCollectionObservable
    private(set) var nfts: [NFT] = []
    var nftsObserve: NFTCollectionObservable<[NFT]> { $nfts }

    @NFTCollectionObservable
    private(set) var isLoaded: Bool = false
    var isLoadedObserve: NFTCollectionObservable<Bool> { $isLoaded }

    @NFTCollectionObservable
    private(set) var orders: [String] = []
    var ordersObserve: NFTCollectionObservable<[String]> { $orders }

    @NFTCollectionObservable
    private(set) var favorites: [String] = []
    var favoritesObserve: NFTCollectionObservable<[String]> { $favorites }

    private(set) var name: String?
    private(set) var author: String?
    private(set) var description: String?
    private(set) var imageURL: URL?

    private(set) var numberOfRows = 0
    private let collection: NFTCollection

    private(set) var networkService: NFTNetworkServiceProtocol

    init(with collection: NFTCollection, networkService: NFTNetworkServiceProtocol) {
        self.collection = collection
        self.networkService = networkService
    }

    func initialize() {

        isLoaded = false
        name = collection.name
        author = collection.author
        description = collection.description
        if let imageEncodedString = collection.imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
           let imageUrl = URL(string: imageEncodedString) {
            imageURL = imageUrl
        }

        loadNFTCollectionFromApi()
    }

    private func loadNFTCollectionFromApi() {

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        networkService.loadFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(favorites):
                self.favorites = favorites.likes
                dispatchGroup.leave()
            case let .failure(error):
                print("error favorites")
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        networkService.loadOrders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(nfts):
                self.orders = nfts
                dispatchGroup.leave()
            case let .failure(error):
                print("error ordrers")
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let nftDispatchGroup = DispatchGroup()
            for nftId in collection.nfts {
                networkService.loadNFT(id: nftId, dispatchGroup: nftDispatchGroup) { result in
                    switch result {
                    case let .success(nft):
                        self.nfts.append(nft)
                    case .failure:
                        print("error nft \(nftId)")
                    }
                }
            }

            nftDispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.numberOfRows = self.nfts.count
                self.isLoaded = true
            }
        }
    }

    func nft(at indexPath: IndexPath) -> NFT? {
        return nfts[indexPath.row]
    }

    func getCellViewModel(for nft: NFT) -> NFTCellViewModel {
        var nftImageURL = imageURL
        if let imageEncodedString = nft.imageStrings[0].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
           let url = URL(string: imageEncodedString) {
            nftImageURL = url
        }

        let nftFavorite = favorites.contains(nft.id)
        let nftCart = orders.contains(nft.id)

        let cellViewModel = NFTCellViewModel(
            name: nft.name,
            price: nft.price,
            rating: nft.rating,
            imageURL: nftImageURL,
            favorite: nftFavorite,
            cart: nftCart)
        return cellViewModel
    }

    func getDescriptionCellViewModel() -> NFTCollectionDescriptionCellViewModel {
        let cellViewModel = NFTCollectionDescriptionCellViewModel(
            name: name!,
            author: author!,
            description: description!,
            imageURL: imageURL)
        return cellViewModel
    }

    func favoriteButtonTapped(at indexPath: IndexPath) {
        let nft = nfts[indexPath.row]
        let nftFavorite = favorites.contains(nft.id)

        if nftFavorite {
            guard let index = favorites.firstIndex(of: nft.id) else { return }
            favorites.remove(at: index)
        } else {
            favorites.append(nft.id)
        }

        networkService.updateFavorites(newFavorites: favorites)
    }

    func cartButtonTapped(at indexPath: IndexPath) {
        let nft = nfts[indexPath.row]
        let nftCart = orders.contains(nft.id)

        if nftCart {
            guard let index = orders.firstIndex(of: nft.id) else { return }
            orders.remove(at: index)
        } else {
            orders.append(nft.id)
        }

        networkService.updateOrders(newOrders: orders)
    }
}
