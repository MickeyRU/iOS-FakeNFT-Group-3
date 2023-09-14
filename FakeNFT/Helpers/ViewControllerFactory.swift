import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        return controller
    }
    
    func makeUserNFTViewController(profile: UserProfile) -> MyNFTViewController {
        return MyNFTViewController(viewModel: MyNFTViewModel(nftService: NFTService.shared,
                                                             profileService: ProfileService.shared, userProfile: profile))
    }
    
    func makeFavoritesNFTViewController(nftList: [String]) -> FavoritesNFTViewController {
        return FavoritesNFTViewController(nftList: nftList,
                                          viewModel: FavoritesNFTViewModel(nftService: NFTService.shared,
                                                                           profileService: ProfileService.shared))
    }
    
    func makeEditingViewController() -> EditingViewController {
        return EditingViewController(viewModel: EditingViewModel(profileService: ProfileService.shared))
    }
}
