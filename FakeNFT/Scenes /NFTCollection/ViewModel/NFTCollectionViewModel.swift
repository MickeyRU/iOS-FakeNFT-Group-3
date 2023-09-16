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
    private(set) var name: String?
    var nameObserve: NFTCollectionObservable<String?> { $name }

    @NFTCollectionObservable
    private(set) var author: String?
    var authorObserve: NFTCollectionObservable<String?> { $author }

    @NFTCollectionObservable
    private(set) var description: String?
    var descriptionObserve: NFTCollectionObservable<String?> { $description }

    @NFTCollectionObservable
    private(set) var imageURL: URL?
    var imageURLObserve: NFTCollectionObservable<URL?> { $imageURL }

    @NFTCollectionObservable
    private(set) var isLoaded: Bool = false
    var isLoadedObserve: NFTCollectionObservable<Bool> { $isLoaded }

    @NFTCollectionObservable
    private(set) var orders: [String] = []
    var ordersObserve: NFTCollectionObservable<[String]> { $orders }

    @NFTCollectionObservable
    private(set) var favorites: [String] = []
    var favoritesObserve: NFTCollectionObservable<[String]> { $favorites }

    private(set) var numberOfRows = 0
    private let collection: NFTCollection

    private let networkClient = DefaultNetworkClient()

    init(with collection: NFTCollection) {
        self.collection = collection
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
        let group = DispatchGroup()
        loadFavorites(dispatchGroup: group)
        loadOrders(dispatchGroup: group)

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.loadNFT()
        }
    }

    private func loadFavorites(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1"))
        networkClient.send(request: request, type: NFTFavorites.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(favorites):
                DispatchQueue.main.async {
                    self.favorites = favorites.likes
                    dispatchGroup.leave()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    print("error favorites")
                    dispatchGroup.leave()
                }
            }
        }
    }

    private func loadOrders(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/orders/1"))
        networkClient.send(request: request, type: NFTOrders.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(orders):
                DispatchQueue.main.async {
                    self.orders = orders.nfts
                    dispatchGroup.leave()
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    print("error ordrers")
                    dispatchGroup.leave()
                }
            }
        }
    }

    private func loadNFT() {
        let dispatchGroup = DispatchGroup()
        for nftId in collection.nfts {
            dispatchGroup.enter()
            let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/nft/\(nftId)"))
            networkClient.send(request: request, type: NFT.self) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(nft):
                    DispatchQueue.main.async {
                        self.nfts.append(nft)
                        dispatchGroup.leave()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        print("error nft \(nftId)")
                        dispatchGroup.leave()
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.numberOfRows = self.nfts.count
            self.isLoaded = true
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

    func favoriteButtonTapped(at indexPath: IndexPath) {
        let nft = nfts[indexPath.row]
        let nftFavorite = favorites.contains(nft.id)

        if nftFavorite {
            guard let index = favorites.firstIndex(of: nft.id) else { return }
            favorites.remove(at: index)
        } else {
            favorites.append(nft.id)
        }

        let request = UpdateRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1"), dto: NFTFavorites(likes: favorites))
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("success")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Unable to update favorites")
                }
            }
        }

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

        let request = UpdateRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/orders/1"), dto: NFTOrders(nfts: orders))
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("success")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Unable to ypdate cart")
                }
            }
        }

    }
}
