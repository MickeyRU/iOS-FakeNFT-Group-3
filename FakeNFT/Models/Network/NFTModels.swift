import Foundation

struct NFT: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}

struct NFTDisplayModel {
    let nft: NFT
    var isSelected: Bool
    
    init(from nft: NFT, likedIds: [String]) {
        self.nft = nft
        self.isSelected = likedIds.contains(nft.id)
    }
}
