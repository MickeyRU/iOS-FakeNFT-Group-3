//
//  NFTCollectionViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 07.09.2023.
//

import Foundation

final class NFTCollectionViewModel: NFTCollectionViewModelProtocol {
    @NFTCollectionObservable
    private(set) var nfts: [NFT]?
    var nftsObserve: NFTCollectionObservable<[NFT]?> { $nfts }

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

    private(set) var numberOfRows = 0

    func initialize(with collection: NFTCollection) {
        name = collection.name
        author = collection.author
        description = collection.description
        if let imageEncodedString = collection.imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
           let imageUrl = URL(string: imageEncodedString) {
            imageURL = imageUrl
        }

        nfts = [
            NFT(
                id: "49",
                name: "Archie",
                imageStrings: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
                ],
                author: "18",
                description: "An animated gif of a bear fishing.",
                rating: 5,
                price: 7.74),
            NFT(
                id: "49",
                name: "Archie",
                imageStrings: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
                ],
                author: "18",
                description: "An animated gif of a bear fishing.",
                rating: 5,
                price: 7.74),
            NFT(
                id: "49",
                name: "Archie",
                imageStrings: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
                ],
                author: "18",
                description: "An animated gif of a bear fishing.",
                rating: 5,
                price: 7.74),
            NFT(
                id: "49",
                name: "Archie",
                imageStrings: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
                ],
                author: "18",
                description: "An animated gif of a bear fishing.",
                rating: 5,
                price: 7.74)
         ]
        numberOfRows = nfts?.count ?? 0
    }

    func nft(at indexPath: IndexPath) -> NFT? {
        guard let nfts = nfts else {
            return nil
        }

        return nfts[indexPath.row]
    }

    func getCellViewModel(for nft: NFT) -> NFTCellViewModel {
        let cellViewModel = NFTCellViewModel(
            name: nft.name,
            price: nft.price,
            rating: nft.rating,
            imageURL: imageURL,
            favorite: false,
            cart: false)
        return cellViewModel
    }

}
