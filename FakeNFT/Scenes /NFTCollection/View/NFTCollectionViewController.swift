//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 03.09.2023.
//

import UIKit
import Kingfisher

final class NFTCollectionViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold22
        label.textColor = .unBlack
        return label
    }()

    private let authorTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.textColor = .unBlack
        label.text = NSLocalizedString("author", comment: "author title")
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular15
        label.textColor = UIColor(red: 0.039, green: 0.518, blue: 1, alpha: 1)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorLabelTapped)))
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.textColor = .unBlack
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var collectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(NFTCell.self)
        collection.backgroundColor = .unWhite
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
        setupNavigationItem()
        setupView()
        setupConstraints()

        bind()
        viewModel.initialize()
    }

    private func bind() {
        viewModel.nameObserve.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.nameLabel.text = newValue
        })

        viewModel.authorObserve.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.authorLabel.text = newValue
        })

        viewModel.descriptionObserve.bind(action: { [weak self] newValue in
            guard let self = self else { return }
            self.descriptionLabel.text = newValue
        })

        viewModel.imageURLObserve.bind(action: { [weak self] newValue in
            guard let self = self, let imageURL = newValue else { return }
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: imageURL)
            }
        })

        viewModel.nftsObserve.bind(action: { [weak self] _ in
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

    @objc
    private func authorLabelTapped() {
        let vc = UINavigationController(
            rootViewController: AuthorWebViewController(viewModel: AuthorWebViewModel()))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

// MARK: - CollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nft = viewModel.nft(at: indexPath) else {
            return UICollectionViewCell()
        }
        let cell: NFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.viewModel = viewModel.getCellViewModel(for: nft)
        return cell
    }
}
// MARK: - CollectionViewDelegate
extension NFTCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edgePadding: CGFloat = 32
        let totalSpaceBetweenCells: CGFloat = 18
        let amountOfCellsInARow: CGFloat = 3
        let cellHeight: CGFloat = 192
        return CGSize(width: (view.bounds.width - edgePadding - totalSpaceBetweenCells) / amountOfCellsInARow, height: cellHeight)
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
        view.addViewWithNoTAMIC(imageView)
        view.addViewWithNoTAMIC(nameLabel)
        view.addViewWithNoTAMIC(authorTitleLabel)
        view.addViewWithNoTAMIC(authorLabel)
        view.addViewWithNoTAMIC(descriptionLabel)
        view.addViewWithNoTAMIC(collectionView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4),
            authorLabel.centerYAnchor.constraint(equalTo: authorTitleLabel.centerYAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
