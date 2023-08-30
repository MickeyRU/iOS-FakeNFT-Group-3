import Foundation

final class ProfileViewModel {
    @Observable
    private(set) var userProfile: UserProfileModel?
    
    private let model: ProfileModel
    
    init(model: ProfileModel) {
        self.model = model
    }
    
    func getUserProfileData() {
        userProfile = model.mockProfileData
    }
    
    func updateUserProfileData(profile: UserProfileModel) {
        userProfile = profile
    }
}
