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
    private let networkClient = DefaultNetworkClient()

    func initialize() {
        let request = ExampleRequest(endpoint: URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/collections"))
        networkClient.send(request: request, type: [NFTCollection].self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(collections):
                DispatchQueue.main.async {
                    self.collections = collections
                    self.numberOfRows = self.collections?.count ?? 0
                }
            case .failure:
                print("Unable to load collections")
            }
        }
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

    func sort(handler: (NFTCollection, NFTCollection) -> Bool) {
        collections?.sort(by: {
            handler($0, $1)
        })
     }

}
