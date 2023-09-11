import UIKit

final class FavoritesNFTViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavigationBar()
    }
    
    private func configNavigationBar() {
        setupCustomBackButton()
        navigationItem.title = NSLocalizedString("FavoritesNFT", comment: "")
    }
}

