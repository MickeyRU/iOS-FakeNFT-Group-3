import UIKit

final class FavoritesNFTViewController: UIViewController {
    private let geometricParams: GeometricParams = {
        GeometricParams(cellPerRowCount: 2,
                        cellSpacing: 7,
                        cellLeftInset: 16,
                        cellRightInset: 16,
                        cellHeight: 80)
    }()

    private lazy var nftCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.register(FavoritesNFTCell.self)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configNavigationBar()
        setupViews()
    }
    
    private func configNavigationBar() {
        setupCustomBackButton()
        navigationItem.title = NSLocalizedString("FavoritesNFT", comment: "")
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addViewWithNoTAMIC(nftCollectionView)
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - FavoritesNFTViewController

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoritesNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - geometricParams.paddingWight) / geometricParams.cellPerRowCount
        return CGSize(width: width, height: geometricParams.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: geometricParams.cellLeftInset, bottom: 0, right: geometricParams.cellRightInset)
    }
}
