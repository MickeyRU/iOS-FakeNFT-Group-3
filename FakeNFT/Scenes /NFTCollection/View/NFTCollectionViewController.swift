//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 03.09.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class NFTCollectionViewController: UIViewController {
    private lazy var collectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(NFTCell.self)
        collection.register(NFTCollectionDescriptionCell.self)
        collection.backgroundColor = .unWhite
        collection.contentInsetAdjustmentBehavior = .never
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    private let viewModel: NFTCollectionViewModelProtocol

    init(viewModel: NFTCollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupView()
        setupConstraints()
        setupNavigationItem()

        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        bind()
        viewModel.initialize()
    }

    func favoriteButtonTapped(cell: NFTCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            viewModel.favoriteButtonTapped(at: indexPath)
        }
    }

    func cartButtonTapped(cell: NFTCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            viewModel.cartButtonTapped(at: indexPath)
        }
    }

    private func bind() {
        viewModel.isLoadedObserve.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            if newValue {
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.show()
            }
        })

        viewModel.nftsObserve.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })

        viewModel.favoritesObserve.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })

        viewModel.ordersObserve.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }

    func authorLabelTapped() {
        let vc = UINavigationController(
            rootViewController: AuthorWebViewController(viewModel: AuthorWebViewModel()))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - CollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel.numberOfRows
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: NFTCollectionDescriptionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel.getDescriptionCellViewModel()
            cell.delegate = self
            return cell
        } else {
            guard let nft = viewModel.nft(at: indexPath) else {
                return UICollectionViewCell()
            }
            let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel = viewModel.getCellViewModel(for: nft)
            cell.delegate = self
            return cell
        }
    }
}
// MARK: - CollectionViewDelegate
extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 124, left: 16, bottom: 0, right: 16)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: - UI
private extension NFTCollectionViewController {
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        barItem.tintColor = .unBlack
        navigationItem.leftBarButtonItem = barItem
    }

    func setupView() {
        view.addViewWithNoTAMIC(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
