//
//  NFTCellViewModel.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 09.09.2023.
//

import Foundation

struct NFTCellViewModel {
    let name: String
    let price: Float
    let rating: Int
    let imageURL: URL?
    let favorite: Bool
    let cart: Bool
}
