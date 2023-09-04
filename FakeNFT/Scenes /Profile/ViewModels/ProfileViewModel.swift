import Foundation
import ProgressHUD

protocol ProfileViewModelProtocol {
    var userProfile: UserProfileModel? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfileModel?) -> Void)
    
    func fetchUserProfile()
    
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
    
    func fetchUserProfile() {
        ProgressHUD.show("Загрузка...")

        model.fetchProfile { [weak self] result in
            guard let self = self else { return }
            ProgressHUD.dismiss()
            switch result {
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let error):
                //ToDo: - Уведомление об ошибке
                print(error)
            }
        }
    }
    
    
    func updateName(_ name: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: name,
                avatar: currentProfile.avatar,
                description: currentProfile.description,
                website: currentProfile.website,
                nfts: currentProfile.nfts,
                likes: currentProfile.likes,
                id: currentProfile.id
            )
        }
    }
    
    func updateDescription(_ description: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: currentProfile.name,
                avatar: currentProfile.avatar,
                description: description,
                website: currentProfile.website,
                nfts: currentProfile.nfts,
                likes: currentProfile.likes,
                id: currentProfile.id
            )
        }
        
    }
    
    func updateWebSite(_ website: String) {
        if let currentProfile = userProfile {
            userProfile = UserProfileModel(
                name: currentProfile.name,
                avatar: currentProfile.avatar,
                description: currentProfile.description,
                website: website,
                nfts: currentProfile.nfts,
                likes: currentProfile.likes,
                id: currentProfile.id
            )
        }
    }
    
    func updateImageURL(url: URL) {
        print("updateImageURL, \(url)")
        // ToDo: Логика проверки и обновления URL в модели ->  в сети
    }
}
