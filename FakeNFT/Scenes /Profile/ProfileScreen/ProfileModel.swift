import Foundation

final class ProfileModel {
    private let networkClient: NetworkClient
    
    init() {
        self.networkClient = DefaultNetworkClient()
    }
    
    func fetchProfile(request: NetworkRequest = FetchProfileNetworkRequest(),
                      completion: @escaping (Result<UserProfile, Error>) -> Void) {
        networkClient.send(request: request, type: UserProfile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(with userProfileModel: UserProfile,
                       completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = UpdateProfileNetworkRequest(userProfile: userProfileModel)
            networkClient.send(request: request, type: UserProfile.self) { result in
                switch result {
                case .success(let updatedProfile):
                    completion(.success(updatedProfile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
