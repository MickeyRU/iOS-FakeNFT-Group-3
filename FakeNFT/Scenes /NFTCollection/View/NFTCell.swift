//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 05.09.2023.
//

import UIKit
import Kingfisher

final class NFTCell: UICollectionViewCell {
    static let identifier = "NFTCell"

    private let imageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let favoriteButton = {
        let button = UIButton()
        return button
    }()

    private let ratingStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        return stack
    }()

    private let descriptionStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        return stack
    }()

    private let descriptionPlusCartStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillProportionally
        return stack
    }()

    private let ratingImageViewOne = {
        let imageView = UIImageView()
        return imageView
    }()

    private let ratingImageViewTwo = {
        let imageView = UIImageView()
        return imageView
    }()

    private let ratingImageViewThree = {
        let imageView = UIImageView()
        return imageView
    }()

    private let ratingImageViewFour = {
        let imageView = UIImageView()
        return imageView
    }()

    private let ratingImageViewFive = {
        let imageView = UIImageView()
        return imageView
    }()

    private let nameLabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        label.textColor = .unBlack
        return label
    }()

    private let priceLabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular10
        label.textColor = .unBlack
        return label
    }()

    private let cartButton = {
        let button = UIButton()
        return button
    }()

    private let ratingImageViews: [UIImageView]

    var viewModel: NFTCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            nameLabel.text = viewModel.name
            priceLabel.text = "\(viewModel.price) ETH"
            setupRating(with: viewModel.rating)
            favoriteButton.setImage(viewModel.favorite ? UIImage(named: "favorites.delete") : UIImage(named: "favorites.add"), for: .normal)
            cartButton.setImage(viewModel.cart ? UIImage(named: "cart.delete") : UIImage(named: "cart.add"), for: .normal)
            if let imageUrl = viewModel.imageURL {
                imageView.kf.setImage(with: imageUrl)
            }
        }
    }

    override init(frame: CGRect) {
        ratingImageViews = [
            ratingImageViewOne, ratingImageViewTwo,
            ratingImageViewThree, ratingImageViewFour,
            ratingImageViewFive
        ]

        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRating(with rating: Int) {
        for position in 0..<5 {
            let ratingStar = ratingImageViews[position]
            if rating >= position + 1 {
                ratingStar.image = UIImage(named: "star.active")
            } else {
                ratingStar.image = UIImage(named: "star.inactive")
            }
        }
    }
}

// MARK: - UI
extension NFTCell {
    func setupView() {
        contentView.addViewWithNoTAMIC(imageView)
        contentView.addViewWithNoTAMIC(favoriteButton)

        ratingStack.addArrangedSubview(ratingImageViewOne)
        ratingStack.addArrangedSubview(ratingImageViewTwo)
        ratingStack.addArrangedSubview(ratingImageViewThree)
        ratingStack.addArrangedSubview(ratingImageViewFour)
        ratingStack.addArrangedSubview(ratingImageViewFive)
        contentView.addViewWithNoTAMIC(ratingStack)

        descriptionStack.addArrangedSubview(nameLabel)
        descriptionStack.addArrangedSubview(priceLabel)
        descriptionPlusCartStack.addArrangedSubview(descriptionStack)
        descriptionPlusCartStack.addArrangedSubview(cartButton)

        contentView.addViewWithNoTAMIC(descriptionPlusCartStack)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 42),
            favoriteButton.heightAnchor.constraint(equalToConstant: 42),
            ratingStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: 68),
            ratingImageViewOne.widthAnchor.constraint(equalToConstant: 12),
            ratingImageViewOne.heightAnchor.constraint(equalToConstant: 12),
            ratingImageViewTwo.widthAnchor.constraint(equalToConstant: 12),
            ratingImageViewTwo.heightAnchor.constraint(equalToConstant: 12),
            ratingImageViewThree.widthAnchor.constraint(equalToConstant: 12),
            ratingImageViewThree.heightAnchor.constraint(equalToConstant: 12),
            ratingImageViewFour.widthAnchor.constraint(equalToConstant: 12),
            ratingImageViewFour.heightAnchor.constraint(equalToConstant: 12),
            ratingImageViewFive.widthAnchor.constraint(equalToConstant: 12),
            ratingImageViewFive.heightAnchor.constraint(equalToConstant: 12),
            descriptionPlusCartStack.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 5),
            descriptionPlusCartStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionPlusCartStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionPlusCartStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
