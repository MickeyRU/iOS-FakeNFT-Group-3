//
//  CatalogCellViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import Foundation

final class CatalogCellViewModel {
    var collectionTitle: String
    var imageString: String

    init(collectionTitle: String, imageString: String) {
        self.collectionTitle = collectionTitle
        self.imageString = imageString
    }
}
