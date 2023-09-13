//
//  NftItemsRequest.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 10.09.2023.
//

import Foundation

struct NFTItemsRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get

    var dto: Encodable?

    var endpoint: URL? {
        .init(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/nft")
    }
}
