import Foundation
import ProgressHUD

protocol FavoritesNFTViewModelProtocol {
    var favoritesNFT: [NFT]? { get }
    var state: LoadingState { get }
    
    func observeFavoritesNFT(_ handler: @escaping ([NFT]?) -> Void)
    func observeState(_ handler: @escaping (LoadingState) -> Void)
    
    func viewDidLoad(nftList: [String])
    func viewWillDisappear()
    func fetchNFT(nftList: [String])
    func dislike(for: NFT)
}

final class FavoritesNFTViewModel: FavoritesNFTViewModelProtocol {
    @Observable
    private (set) var favoritesNFT: [NFT]?
    
    @Observable
    private (set) var state: LoadingState = .idle
    
    private let service: NFTService
    
    init(nftService: NFTService) {
        self.service = nftService
    }
    
    func observeFavoritesNFT(_ handler: @escaping ([NFT]?) -> Void) {
        $favoritesNFT.observe(handler)
    }
    
    func observeState(_ handler: @escaping (LoadingState) -> Void) {
        $state.observe(handler)
    }
    
    func viewDidLoad(nftList: [String]) {
        self.fetchNFT(nftList: nftList)
    }
    
    func viewWillDisappear() {
        service.stopAllTasks()
        ProgressHUD.dismiss()
    }
    
    func fetchNFT(nftList: [String]) {
        ProgressHUD.show("Загрузка...")
        state = .loading
        
        var fetchedNFTs: [NFT] = []
        let group = DispatchGroup()
        
        for element in nftList {
            group.enter()
            
            service.fetchNFT(nftID: element) { result in
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
            self.state = .loaded
            ProgressHUD.dismiss()
        }
    }
    
    func dislike(for: NFT) {
        print("Пользователь нажал дизлайк")
    }
}
