//
//  NFTCartCellViewModel.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//

import UIKit.UIImage

public struct NFTCartCellViewModel: Equatable {
    let id: String
    let name: String
    let image: UIImage?
    let rating: Int
    let price: Double
}

public typealias OrderViewModel = [NFTCartCellViewModel]
