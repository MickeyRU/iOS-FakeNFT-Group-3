//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import Foundation

final class CatalogViewModel: CatalogViewModelProtocol {
    @CatalogObservable
    private(set) var collections: [NFTCollection]?
    var collectionsObserve: CatalogObservable<[NFTCollection]?> { $collections }
    private(set) var numberOfRows = 0

    func initialize() {
        collections = [
            NFTCollection(
                id: "1",
                name: "Peach",
                imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png",
                nfts: ["1", "2", "3"],
                author: "Author",
                description: "Some description of collection"),
            NFTCollection(id: "2",
                name: "Blue",
                imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png",
                nfts: ["1", "2" ],
                author: "Author",
                description: "Some description of collection"),
            NFTCollection(
                id: "3",
                name: "Brown",
                imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
                nfts: ["1", "2", "3", "4"],
                author: "Author", description: "Some description of collection"
            )
        ]
        numberOfRows = collections?.count ?? 0
    }

    func collection(at indexPath: IndexPath) -> NFTCollection? {
        guard let collections = collections else {
            return nil
        }

        return collections[indexPath.row]
    }

    func getCellViewModel(for collection: NFTCollection) -> CatalogCellViewModel {
        let cellViewModel = CatalogCellViewModel(
            collectionTitle: "\(collection.name) (\(collection.nfts.count))",
            imageString: collection.imageString)
        return cellViewModel
    }

}
