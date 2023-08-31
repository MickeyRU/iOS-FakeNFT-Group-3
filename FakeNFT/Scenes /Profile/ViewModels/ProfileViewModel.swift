import Foundation

protocol ProfileViewModelProtocol {
    var userProfile: UserProfileModel? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfileModel?) -> Void)
    func getUserProfileData()
    func updateUserProfileData(profile: UserProfileModel)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfileModel?
    
    private let model: ProfileModel
    
    init(model: ProfileModel) {
        self.model = model
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfileModel?) -> Void) {
        $userProfile.bind(action: handler)
    }
    
    func getUserProfileData() {
        userProfile = model.mockProfileData
    }
    
    func updateUserProfileData(profile: UserProfileModel) {
        userProfile = profile
    }
}
