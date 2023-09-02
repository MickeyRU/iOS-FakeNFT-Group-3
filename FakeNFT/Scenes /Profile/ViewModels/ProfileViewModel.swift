import Foundation

protocol ProfileViewModelProtocol {
    var userProfile: UserProfileModel? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfileModel?) -> Void)
    
    func getUserProfile()
    
    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebSite(_ website: String)
    func updateImageURL(url: URL)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfileModel?
    
    private let model: ProfileModel
    
    init(model: ProfileModel) {
        self.model = model
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfileModel?) -> Void) {
        $userProfile.observe(handler)
    }
    
    func getUserProfile() {
        userProfile = model.mockProfileData
        // ToDo: Загрузка данных из сети
    }
    
    func updateName(_ name: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: name,
                avatar: currentProfile.avatar,
                description: currentProfile.description,
                webSite: currentProfile.webSite
            )
        }
    }
    
    func updateDescription(_ description: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: currentProfile.name,
                avatar: currentProfile.avatar,
                description: description,
                webSite: currentProfile.webSite
            )
        }

    }
    
    func updateWebSite(_ website: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: currentProfile.name,
                avatar: currentProfile.avatar,
                description: currentProfile.description,
                webSite:website
            )
        }
    }
    
    func updateImageURL(url: URL) {
        print("updateImageURL, \(url)")
        // ToDo: Логика проверки и обновления URL в модели ->  в сети
    }
}
