//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 03.09.2023.
//

import UIKit
import Kingfisher

class NFTCollectionViewController: UIViewController {

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
        label.font = UIFont.sfRegular22
        label.textColor = .unBlack
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.textColor = .unBlack
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

    private let collectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(NFTCell.self, forCellWithReuseIdentifier: NFTCell.identifier)
        collection.backgroundColor = .unWhite
        return collection
    }()

    private let collection: NFTCollection
    private let viewModel: NFTCollectionViewModelProtocol

    init(with collection: NFTCollection, viewModel: NFTCollectionViewModelProtocol) {
        self.collection = collection
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

        collectionView.dataSource = self
        collectionView.delegate = self

        bind()
        viewModel.initialize(with: collection)
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
}

// MARK: - CollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCell.identifier, for: indexPath) as? NFTCell,
            let nft = viewModel.nft(at: indexPath) else {
            return UICollectionViewCell()
        }

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
        return CGSize(width: (view.bounds.width - 32 - 18) / 3, height: 192)
    }
}

// MARK: - UI
extension NFTCollectionViewController {
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        barItem.tintColor = .unBlack
        navigationItem.leftBarButtonItem = barItem
    }

    private func setupView() {
        view.addViewWithNoTAMIC(imageView)
        view.addViewWithNoTAMIC(nameLabel)
        view.addViewWithNoTAMIC(authorLabel)
        view.addViewWithNoTAMIC(descriptionLabel)
        view.addViewWithNoTAMIC(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
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
