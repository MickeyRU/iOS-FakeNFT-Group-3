//
//  NftCollectionNetworkService.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import Foundation

protocol NFTNetworkService {
    func getNFTCollection(
        result: @escaping ResultHandler<NFTCollectionResponse>
    )

    func getNFTItem(
        result: @escaping ResultHandler<NFTItemResponse>
    )
}

public protocol NFTNetworkCartService {
    func getNFTItemBy(
        id: String,
        result: @escaping ResultHandler<NFTItemModel>
    )
}
