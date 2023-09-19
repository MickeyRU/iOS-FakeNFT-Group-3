//
//  NFT.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 05.09.2023.
//

import Foundation

struct NFT: Decodable {
    let id: String
    let name: String
    let imageStrings: [String]
    let author: String
    let description: String
    let rating: Int
    let price: Float
    enum CodingKeys: String, CodingKey {
        case id, name, imageStrings = "images", author, description, rating, price
    }
}
