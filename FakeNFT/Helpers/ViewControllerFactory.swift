import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        return controller
    }
    
    func makeUserNFTViewController(nftList: [String]) -> UserNFTViewController {
        let userNFTViewController = UserNFTViewController(nftList: nftList,
                                                          viewModel: UserNFTViewModel(nftService: NFTService.shared))
        return userNFTViewController
    }
    
    func makeFavoritesNFTViewController() -> FavoritesNFTViewController {
        return FavoritesNFTViewController()
    }
    
    func makeEditingViewController() -> EditingViewController {
        return EditingViewController(viewModel: EditingViewModel(profileService: ProfileService.shared))
    }
}
