import UIKit

final class ViewControllerFactory {
    func makeWebView(url: URL) -> WebViewViewController {
        let controller = WebViewViewController(url: url)
        // TODO: - индикатор загрузки
        return controller
    }
    
    func makeUserNFTViewController() -> UserNFTViewController {
            return UserNFTViewController()
        }

    func makeFavoritesNFTViewController() -> FavoritesNFTViewController {
            return FavoritesNFTViewController()
    }
    
    func makeEditingViewController(with profile: UserProfileModel, delegate: EditingViewControllerProtocol) -> EditingViewController {
            return EditingViewController(userProfile: profile, delegate: delegate)
    }
}
