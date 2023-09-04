import Foundation

struct UserProfileModel: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

final class ProfileModel {
    private let networkClient: NetworkClient
    private let request: NetworkRequest
    
    init() {
        self.networkClient = DefaultNetworkClient()
        self.request = ProfileNetworkRequest()
    }
    
    func fetchProfile(completion: @escaping (Result<UserProfileModel, Error>) -> Void) {
        networkClient.send(request: request, type: UserProfileModel.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
