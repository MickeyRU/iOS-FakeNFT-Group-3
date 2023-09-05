import Foundation

struct FetchNFTNetworkRequest: NetworkRequest {
    let nftID: String
    
    var endpoint: URL? {
        URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/nft/\(nftID)")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    init(nftID: String) {
        self.nftID = nftID
    }
}

struct FetchAuthorNetworkRequest: NetworkRequest {
    let authorID: String

    var endpoint: URL? {
        URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/users/\(authorID)")
    }

    var httpMethod: HttpMethod {
        return .get
    }
}
