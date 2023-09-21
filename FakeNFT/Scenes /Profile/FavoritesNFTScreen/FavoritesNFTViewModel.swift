import Foundation
import ProgressHUD

protocol FavoritesNFTViewModelProtocol {
    var favoritesNFT: [ProfileNFT] { get }
    var state: LoadingState { get }
    
    func observeFavoritesNFT(_ handler: @escaping ([ProfileNFT]?) -> Void)
    func observeState(_ handler: @escaping (LoadingState) -> Void)
    
    func viewDidLoad(nftList: [String])
    func viewWillDisappear()
    func fetchNFT(nftList: [String])
    func dislike(for: ProfileNFT)
}

final class FavoritesNFTViewModel: FavoritesNFTViewModelProtocol {
    @Observable
    private (set) var favoritesNFT: [ProfileNFT] = []
    
    @Observable
    private (set) var state: LoadingState = .idle
    
    private let nftService: NFTService
    private let profileService: ProfileService
    
    init(nftService: NFTService, profileService: ProfileService) {
        self.nftService = nftService
        self.profileService = profileService
    }
    
    func observeFavoritesNFT(_ handler: @escaping ([ProfileNFT]?) -> Void) {
        $favoritesNFT.observe(handler)
    }
    
    func observeState(_ handler: @escaping (LoadingState) -> Void) {
        $state.observe(handler)
    }
    
    func viewDidLoad(nftList: [String]) {
        self.fetchNFT(nftList: nftList)
    }
    
    func viewWillDisappear() {
        nftService.stopAllTasks()
        NotificationCenter.default.post(name: NSNotification.Name("profileUpdated"), object: nil)
        ProgressHUD.dismiss()
    }
    
    func fetchNFT(nftList: [String]) {
        ProgressHUD.show(NSLocalizedString("Loading", comment: ""))
        state = .loading
        
        var fetchedNFTs: [ProfileNFT] = []
        let group = DispatchGroup()
        
        for element in nftList {
            group.enter()
            
            nftService.fetchNFT(nftID: element) { result in
                switch result {
                case .success(let nft):
                    fetchedNFTs.append(nft)
                case .failure(let error):
                    print("Failed to fetch NFT with ID \(element): \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.favoritesNFT = fetchedNFTs
            self.state = .loaded(hasData: !fetchedNFTs.isEmpty)
            ProgressHUD.dismiss()
        }
    }
    
    func dislike(for nft: ProfileNFT) {
        // Алгоритм удаления лайков - через обновление profile
        // Шаг 1: Получить профиль пользователя
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userProfile):
                // Шаг 2: Обновить профиль
                let updatedLikes = userProfile.likes.filter { $0 != nft.id }
                self.fetchNFT(nftList: updatedLikes)
                let updatedProfile = UserProfile(
                    name: userProfile.name,
                    avatar: userProfile.avatar,
                    description: userProfile.description,
                    website: userProfile.website,
                    nfts: userProfile.nfts,
                    likes: updatedLikes,
                    id: userProfile.id
                )
                
                // Шаг 3: Опубликовать новый профиль на сервере
                self.profileService.updateProfile(with: updatedProfile) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        // ToDo: - обработать ошибку
                        print(error)
                    }
                }
            case.failure(let error):
                // ToDo: - обработать ошибку
                print(error)
            }
        }
    }
}
