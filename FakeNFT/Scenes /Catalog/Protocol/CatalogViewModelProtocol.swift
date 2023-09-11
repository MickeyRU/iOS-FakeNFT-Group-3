//
//  CatalogViewModelProtocol.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 03.09.2023.
//

import Foundation

protocol CatalogViewModelProtocol: AnyObject {
    var collections: [NFTCollection]? { get }
    var collectionsObserve: CatalogObservable<[NFTCollection]?> { get }
    var numberOfRows: Int { get }

    func initialize()
    func collection(at indexPath: IndexPath) -> NFTCollection?
    func getCellViewModel(for collection: NFTCollection) -> CatalogCellViewModel
    func sort(handler: (NFTCollection, NFTCollection) -> Bool)
}
