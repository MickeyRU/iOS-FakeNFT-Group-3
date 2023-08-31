//
//  NFTCollection.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import Foundation

struct NFTCollection: Codable {
    var id: String
    var name: String
    var imageString: String
    var nfts: [String]
    var author: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id, name, imageString = "cover", nfts, author, description
    }
}
