//
//  NFTDescriptionCell.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 17.09.2023.
//

import UIKit
import Kingfisher

final class NFTCollectionDescriptionCell: UICollectionViewCell, ReuseIdentifying {
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

    @objc
    private func authorLabelTapped() {
        guard let delegate = delegate else { return }
        delegate.authorLabelTapped()
    }

    var viewModel: NFTCollectionDescriptionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            nameLabel.text = viewModel.name
            authorLabel.text = viewModel.author
            descriptionLabel.text = viewModel.description
            if let imageUrl = viewModel.imageURL {
                imageView.kf.setImage(with: imageUrl)
            }
        }
    }

    weak var delegate: NFTCollectionViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension NFTCollectionDescriptionCell {
    func setupView() {
        contentView.addViewWithNoTAMIC(imageView)
        contentView.addViewWithNoTAMIC(nameLabel)
        contentView.addViewWithNoTAMIC(authorTitleLabel)
        contentView.addViewWithNoTAMIC(authorLabel)
        contentView.addViewWithNoTAMIC(descriptionLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4),
            authorLabel.centerYAnchor.constraint(equalTo: authorTitleLabel.centerYAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
