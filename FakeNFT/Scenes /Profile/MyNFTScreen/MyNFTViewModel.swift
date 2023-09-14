import Foundation
import ProgressHUD

protocol MyNFTViewModelProtocol {
    var userNFTs: [NFT] { get }
    var authors: [String: Author] { get }
    var state: LoadingState { get }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void)
    func observeState(_ handler: @escaping (LoadingState) -> Void)
    
    func viewDidLoad()
    func viewWillDisappear()
    func getNFT(index: Int) -> NFTDisplayModel?
    
    func userSelectedSorting(by option: SortOption)
    func didTapHeartButton(at: Int)
    
}

final class MyNFTViewModel: MyNFTViewModelProtocol {
    private let nftService: NFTService
    private let profileService: ProfileService
    private (set) var userProfile: UserProfile
    
    @Observable
    private (set) var userNFTs: [NFT] = []
    
    @Observable
    private (set) var state: LoadingState = .idle
    
    private (set) var authors: [String: Author] = [:] // Dictionary с ID автора как ключом и данными автора как значением.

    init(nftService: NFTService, profileService: ProfileService, userProfile: UserProfile) {
        self.nftService = nftService
        self.profileService = profileService
        self.userProfile = userProfile
    }
    
    func observeUserNFT(_ handler: @escaping ([NFT]?) -> Void) {
        $userNFTs.observe(handler)
    }
    
    func observeState(_ handler: @escaping (LoadingState) -> Void) {
        $state.observe(handler)
    }
    
    func viewDidLoad() {
        ProgressHUD.show(NSLocalizedString("Loading", comment: ""))
        state = .loading
        
        var fetchedNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for element in userProfile.nfts {
            group.enter()
            
            nftService.fetchNFT(nftID: element) { (result) in
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
            self.fetchAuthorList(nfts: fetchedNFTs)
        }
    }
    
    func viewWillDisappear() {
        nftService.stopAllTasks()
        ProgressHUD.dismiss()
    }
    
    func getNFT(index: Int) -> NFTDisplayModel? {
        let likedIds = userProfile.likes
        let displayUserNFTs = userNFTs.map { NFTDisplayModel(from: $0, likedIds: likedIds) }
        return displayUserNFTs[index]
    }
    
    func userSelectedSorting(by option: SortOption) {
        var nfts: [NFT] = []
        
        switch option {
        case .price:
            nfts.sort(by: { $0.price < $1.price })
        case .rating:
            nfts.sort(by: { $0.rating < $1.rating })
        case .title:
            nfts.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        }
        self.userNFTs = nfts
    }
    
    func didTapHeartButton(at index: Int) {
        guard index < userNFTs.count else { return }
        let selectedNFT = userNFTs[index]

        var updatedLikes: [String]

        if userProfile.likes.contains(selectedNFT.id) {
            updatedLikes = userProfile.likes.filter { $0 != selectedNFT.id }
        } else {
            updatedLikes = userProfile.likes + [selectedNFT.id]
        }

        let updatedProfile = UserProfile(name: userProfile.name,
                                         avatar: userProfile.avatar,
                                         description: userProfile.description,
                                         website: userProfile.website,
                                         nfts: userProfile.nfts,
                                         likes: updatedLikes,
                                         id: userProfile.id)

        profileService.updateProfile(with: updatedProfile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.userProfile = profile
                print("Успех")
            case .failure(let error):
                print("Failed to update profile: \(error)")
            }
        }
    }
    
    private func fetchAuthorList(nfts: [NFT]) {
        let authorGroup = DispatchGroup()
        
        for nft in nfts {
            authorGroup.enter()
            self.fetchAuthor(authorID: nft.author) { result in
                switch result {
                case .success(let author):
                    self.authors[nft.author] = author
                case .failure(let error):
                    print("Failed to fetch author with ID \(nft.author): \(error)")
                }
                authorGroup.leave()
            }
        }
        authorGroup.notify(queue: .main) {
            self.userNFTs = nfts
            self.state = .loaded(hasData: !nfts.isEmpty)
            ProgressHUD.dismiss()
        }
    }
    
    private func fetchAuthor(authorID: String, completion: @escaping (Result<Author, Error>) -> Void) {
        nftService.fetchAuthor(authorID: authorID) { result in
            switch result {
            case .success(let author):
                completion(.success(author))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
