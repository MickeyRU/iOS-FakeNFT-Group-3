//
//  NFTCollectionModel.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import Foundation

struct NFTCollectionModel: Codable {
    let createdAt: Date
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

typealias NFTCollectionResponse = [NFTCollectionModel]
