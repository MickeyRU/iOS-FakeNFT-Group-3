import Foundation

protocol ProfileViewModelProtocol {
    var userProfile: UserProfile? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void)
    
    func fetchUserProfile()
    func saveUserProfile()
    
    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebSite(_ website: String)
    func updateImageURL(with url: URL)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfile?
    
    private let model: ProfileModel
    private let imageValidator: ImageValidatorProtocol
    
    init(model: ProfileModel, imageValidator: ImageValidatorProtocol = ImageValidator()) {
        self.model = model
        self.imageValidator = imageValidator
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void) {
        $userProfile.observe(handler)
    }
    
    func fetchUserProfile() {
        model.fetchProfile { [weak self] result in
            guard let self = self else { return }
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
            userProfile = UserProfile(
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
            userProfile = UserProfile(
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
            userProfile = UserProfile(
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
    
    func updateImageURL(with url: URL) {
        imageValidator.isValidImageURL(url) { [weak self] isValid in
            guard let self = self else { return }
            if isValid,
               let currentProfile = userProfile {
                self.userProfile = UserProfile(
                    name: currentProfile.name,
                    avatar: url.absoluteString,
                    description: currentProfile.description,
                    website: currentProfile.website,
                    nfts: currentProfile.nfts,
                    likes: currentProfile.likes,
                    id: currentProfile.id
                )
            } else {
                // ToDo: Уведомьте пользователя, что URL не является действительным изображением.
            }
        }
    }
    
    func saveUserProfile() {
        guard let userProfile = userProfile else { return }
        model.updateProfile(with: userProfile) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedProfile):
                self.userProfile = updatedProfile
            case .failure(let error):
                //ToDo: - Уведомление об ошибке
                print(error)
            }
        }
    }
}
