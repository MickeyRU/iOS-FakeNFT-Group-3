//
//  NFTCell.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 05.09.2023.
//

import UIKit
import Kingfisher

final class NFTCell: UICollectionViewCell, ReuseIdentifying {
    private let imageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var favoriteButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
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

    private lazy var cartButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return button
    }()

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

    weak var delegate: NFTCollectionViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRating(with rating: Int) {
        for position in 0..<5 {
            if let ratingStar = ratingStack.arrangedSubviews[position] as? UIImageView {
                if rating >= position + 1 {
                    ratingStar.image = UIImage(named: "star.active")
                } else {
                    ratingStar.image = UIImage(named: "star.inactive")
                }
            }
        }
    }

    @objc
    func favoriteButtonTapped() {
        guard let delegate = delegate else { return }
        delegate.favoriteButtonTapped(cell: self)
    }

    @objc
    func cartButtonTapped() {
        guard let delegate = delegate else { return }
        delegate.cartButtonTapped(cell: self)
    }

}

// MARK: - UI
private extension NFTCell {
    func setupView() {
        contentView.addViewWithNoTAMIC(imageView)
        contentView.addViewWithNoTAMIC(favoriteButton)

        for _ in 0..<5 {
            ratingStack.addArrangedSubview(UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12)))
        }
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
            imageView.heightAnchor.constraint(equalToConstant: 108),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 42),
            favoriteButton.heightAnchor.constraint(equalToConstant: 42),
            ratingStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStack.widthAnchor.constraint(equalToConstant: 68),
            descriptionPlusCartStack.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 5),
            descriptionPlusCartStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionPlusCartStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionPlusCartStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
