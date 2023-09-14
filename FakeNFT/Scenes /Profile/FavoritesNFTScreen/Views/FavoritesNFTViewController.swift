import UIKit

final class FavoritesNFTViewController: UIViewController {
    private let viewModel: FavoritesNFTViewModelProtocol
    private let nftList: [String]
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
    
    private lazy var noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас еще нет избранных NFT"
        label.font = UIFont.sfBold17
        label.isHidden = true
        return label
    }()
    
    init(nftList: [String], viewModel: FavoritesNFTViewModelProtocol) {
        self.nftList = nftList
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(nftList: self.nftList)
        
        configNavigationBar()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    private func bind() {
        viewModel.observeFavoritesNFT { [weak self] _ in
            guard let self = self else { return }
            self.nftCollectionView.reloadData()
        }
        
        viewModel.observeState { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                setUIInteraction(false)
            case .loaded:
                guard
                    let favoritesNFT = self.viewModel.favoritesNFT,
                    favoritesNFT.count == 0
                else {
                    self.updateUI(isNoNFT: false)
                    return
                }
                self.updateUI(isNoNFT: true)
            case .error(_):
                print("Ошибка")
                // ToDo: - Error Alert
            default:
                break
            }
        }
    }
    
    private func setUIInteraction(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.nftCollectionView.isUserInteractionEnabled = enabled
            self.navigationItem.leftBarButtonItem?.isEnabled = enabled
            self.nftCollectionView.alpha = enabled ? 1.0 : 0.5
        }
    }
    
    private func updateUI(isNoNFT: Bool) {
        setUIInteraction(true)
        self.noNFTLabel.isHidden = !isNoNFT
        navigationItem.title = isNoNFT ? nil : NSLocalizedString("FavoritesNFT", comment: "")
    }

    
    private func configNavigationBar() {
        setupCustomBackButton()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [nftCollectionView, noNFTLabel].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - FavoritesNFTViewController

extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesNFT?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoritesNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        guard let nft = viewModel.favoritesNFT?[indexPath.row] else { return cell }
        cell.configure(with: nft)
        cell.delegate = self
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
        UIEdgeInsets(top: 20, left: geometricParams.cellLeftInset, bottom: 0, right: geometricParams.cellRightInset)
    }
}

// MARK: - FavoritesNFTCellDelegateProtocol

extension FavoritesNFTViewController: FavoritesNFTCellDelegateProtocol {
    func didTapHeartButton(in cell: FavoritesNFTCell) {
        guard
            let indexPath = nftCollectionView.indexPath(for: cell),
            let nft = viewModel.favoritesNFT?[indexPath.row]
        else { return }
        viewModel.dislike(for: nft)
    }
}
