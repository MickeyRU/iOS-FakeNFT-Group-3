import Foundation
import ProgressHUD

protocol EditingViewModelProtocol {
    var userProfile: UserProfile? { get }
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void)
    
    func viewDidLoad()
    func exitButtonTapped()
    
    func updateName(_ name: String)
    func updateDescription(_ description: String)
    func updateWebSite(_ website: String)
    
    func photoURLdidChanged(with url: URL)
}

final class EditingViewModel: EditingViewModelProtocol {
    @Observable
    private(set) var userProfile: UserProfile?
    
    private let profileService: ProfileService
    private let imageValidator: ImageValidatorServiceProtocol
    
    private var isChanged: Bool = false
    
    init(profileService: ProfileService, imageValidator: ImageValidatorServiceProtocol = ImageValidatorService()) {
        self.profileService = profileService
        self.imageValidator = imageValidator
    }
    
    func observeUserProfileChanges(_ handler: @escaping (UserProfile?) -> Void) {
        $userProfile.observe(handler)
    }
    
    func viewDidLoad() {
        fetchUserProfile()
    }
    
    func updateName(_ name: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
        isChanged = true
    }
    
    func updateDescription(_ description: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: description,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
        isChanged = true
    }
    
    func updateWebSite(_ website: String) {
        guard let currentProfile = userProfile else { return }
        userProfile = UserProfile(
            name: currentProfile.name,
            avatar: currentProfile.avatar,
            description: currentProfile.description,
            website: website,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes,
            id: currentProfile.id
        )
        isChanged = true
    }
    
    func exitButtonTapped() {
        guard isChanged, let userProfile = userProfile else { return }
        
        let group = DispatchGroup()
        let backgroundQueue = DispatchQueue(label: "com.appname.backgroundQueue", qos: .background)

        backgroundQueue.async(group: group) {
            group.enter()
            
            self.profileService.updateProfile(with: userProfile) { [weak self] result in
                defer { group.leave() }
                
                guard let self = self else { return }

                DispatchQueue.main.async {
                    switch result {
                    case .success(let updatedProfile):
                        self.userProfile = updatedProfile
                        NotificationCenter.default.post(name: NSNotification.Name("profileUpdated"), object: nil)
                    case .failure(let error):
                        NotificationCenter.default.post(name: NSNotification.Name("profileUpdateErrorToastNotification"), object: NSLocalizedString("profileUpdateError", comment: ""))
                        print(error)
                    }
                }
            }
        }
    }

    func photoURLdidChanged(with url: URL) {
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
    
    private func fetchUserProfile() {
        ProgressHUD.show(NSLocalizedString("Loading", comment: ""))
        profileService.fetchProfile { [weak self] result in
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
}
