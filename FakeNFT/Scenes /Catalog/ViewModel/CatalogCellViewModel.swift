//
//  CatalogCellViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import Foundation

struct CatalogCellViewModel {
    let collectionTitle: String
    let imageString: String

    init(collectionTitle: String, imageString: String) {
        self.collectionTitle = collectionTitle
        self.imageString = imageString
    }
}
