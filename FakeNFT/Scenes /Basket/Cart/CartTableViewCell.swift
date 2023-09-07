//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import UIKit

final class CartTableViewCell: UITableViewCell, ReuseIdentifying {
    
    private enum Constants {
        static let nftImageViewCornerRadius: CGFloat = 12
        static let nftImageViewEdgeInset: CGFloat = 16
        static let titleLabelTopInset: CGFloat = 8
        static let titleLabelSideInset: CGFloat = 16
        static let starsViewTopInset: CGFloat = 4
        static let starsViewWidth: CGFloat = 68
        static let priceTitleLabelTopInset: CGFloat = 13
        static let priceLabelTopInset: CGFloat = 2
        static var boldFont: UIFont { .sfBold17 }
        static var regularFont: UIFont { .sfRegular13 }
    }
    
    var nft: NFTCartCellViewModel? {
        didSet {
            guard let nft = self.nft else { return }
            self.nftImageView.image = nft.image
            self.titleLabel.text = nft.name
            self.starsView.rating = StarsView.Rating(rawValue: nft.rating) ?? .zero
            self.priceLabel.text = "\(nft.price.nftCurrencyFormatted) ETH"
        }
    }
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .unLightGray
        imageView.layer.cornerRadius = Constants.nftImageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.boldFont
        return label
    }()
    
    private let starsView: StarsView = {
        let view = StarsView()
        view.rating = .zero
        return view
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "cart_cell_title_price".localized
        label.font = Constants.regularFont
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.boldFont
        return label
    }()
    
    private let cartAccessoryView: UIImageView = {
        let image = UIImage.Cart.active.withTintColor(.unBlack)
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nftImageView.image = nil
        titleLabel.text = ""
        starsView.rating = .zero
        priceLabel.text = ""
    }
}

// MARK: - Add subviews / Set constraints

extension CartTableViewCell {
    
    private func addSubviews() {
        backgroundColor = .unWhite
        accessoryView = self.cartAccessoryView
        [nftImageView, titleLabel, starsView, priceTitleLabel, priceLabel].forEach{contentView.addViewWithNoTAMIC($0)}
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.nftImageViewEdgeInset),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: Constants.nftImageViewEdgeInset),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -Constants.nftImageViewEdgeInset),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: Constants.titleLabelTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: Constants.titleLabelSideInset),
            
            starsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.starsViewTopInset),
            starsView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starsView.widthAnchor.constraint(equalToConstant: Constants.starsViewWidth),
            
            priceTitleLabel.topAnchor.constraint(equalTo: starsView.bottomAnchor,constant: Constants.priceTitleLabelTopInset),
            priceTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor,constant: Constants.priceLabelTopInset),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}
