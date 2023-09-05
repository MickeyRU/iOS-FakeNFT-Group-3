import Foundation

struct FetchProfileNetworkRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
}

struct UpdateProfileNetworkRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://64e794b8b0fd9648b7902489.mockapi.io/api/v1/profile/1")
    }

    var httpMethod: HttpMethod {
        return .put
    }

    var dto: Encodable? {
        return profileDTO
    }
    
    let profileDTO: ProfileUpdateDTO
    
    init(userProfile: UserProfileModel) {
        profileDTO = ProfileUpdateDTO(from: userProfile)
    }
}

