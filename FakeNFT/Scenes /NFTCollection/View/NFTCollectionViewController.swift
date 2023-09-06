//
//  NFTCollectionViewController.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 03.09.2023.
//

import UIKit

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
    private let nfts = [
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74),
        NFT(
            id: "49",
            name: "Archie",
            imageStrings: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Archie/3.png"
            ],
            author: "18",
            description: "An animated gif of a bear fishing.",
            rating: 5,
            price: 7.74)
    ]

    init(with collection: NFTCollection) {
        self.collection = collection
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

        if let imageEncodedString = collection.imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let imageUrl = URL(string: imageEncodedString) {
            imageView.kf.setImage(with: imageUrl)
        }
        nameLabel.text = collection.name
        authorLabel.text = "\(NSLocalizedString("author", comment: "author label text")): \(collection.author)"
        descriptionLabel.text = collection.description

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @objc
    func backButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - CollectionViewDataSource
extension NFTCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCell.identifier, for: indexPath) as? NFTCell else {
            return UICollectionViewCell()
        }
        let nft = nfts[indexPath.row]
        cell.setupCell(with: nft)
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
