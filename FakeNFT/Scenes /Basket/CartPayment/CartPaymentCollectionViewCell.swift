//
//  CartPaymentCollectionViewCell.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 11.09.2023.
//

import UIKit

final class CartPaymentCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let labelsLineHeight: CGFloat = 18

        static let currencyImageViewInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 0)

        static let titleLabelTopInset: CGFloat = 4
        static let labelsSideInset: CGFloat = 4
    }

    var currency: CurrencyCellViewModel? {
        didSet {
            self.currencyImageView.image = self.currency?.image
            self.titleLabel.text = self.currency?.title
            self.shortNameLabel.text = self.currency?.name

            self.titleLabel.lineHeight = Constants.labelsLineHeight
            self.shortNameLabel.lineHeight = Constants.labelsLineHeight
        }
    }

    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.cornerRadius / 2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .unBlack
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .unBlack
        label.font = .sfRegular13
        return label
    }()

    private let shortNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .unGreenUniversal
        label.font = .sfRegular13
        return label
    }()

    private lazy var selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderColor = UIColor.unBlack.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        contentView.layer.borderColor = UIColor.unBlack.cgColor
    }
}

extension CartPaymentCollectionViewCell {
    func shouldSelectCell(_ shouldSelect: Bool) {
        contentView.layer.borderWidth = shouldSelect ? 1 : 0
    }
}

//MARK: - Configure / Add subviews / Set constraints

private extension CartPaymentCollectionViewCell {
    func configure() {
        contentView.backgroundColor = .unLightGray
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderColor = UIColor.unBlack.cgColor
        contentView.layer.borderWidth = 0

        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        [currencyImageView, titleLabel, shortNameLabel].forEach{contentView.addViewWithNoTAMIC($0)}
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            currencyImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.currencyImageViewInsets.top
            ),
            currencyImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.currencyImageViewInsets.left
            ),
            currencyImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.currencyImageViewInsets.bottom
            ),
            currencyImageView.widthAnchor.constraint(equalTo: currencyImageView.heightAnchor),

            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.titleLabelTopInset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: currencyImageView.trailingAnchor,
                constant: Constants.labelsSideInset
            ),

            shortNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            shortNameLabel.leadingAnchor.constraint(
                equalTo: currencyImageView.trailingAnchor,
                constant: Constants.labelsSideInset
            )
        ])
    }
}
