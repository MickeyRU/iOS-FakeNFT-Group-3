//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import Foundation

struct NFTCollection: Codable {
    let id: String
    let name: String
    let imageString: String
    let nfts: [String]
    let author: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id, name, imageString = "cover", nfts, author, description
    }
}
