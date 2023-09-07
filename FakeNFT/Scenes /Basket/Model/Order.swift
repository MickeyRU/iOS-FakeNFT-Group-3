//
//  Order.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//

import Foundation

public struct Order: Codable {
    let id: String
    let nfts: [String]
    
    public init(id: String, nfts: [String]) {
        self.id = id
        self.nfts = nfts
    }
}
