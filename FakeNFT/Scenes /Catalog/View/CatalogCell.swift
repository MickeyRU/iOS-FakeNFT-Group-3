//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import UIKit
import Kingfisher

class CatalogCell: UITableViewCell {

    static let identifier = "CatalogCell"

    var collectionCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var collectionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular17
        label.textColor = .unBlack
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(with collection: NFTCollection) {
        collectionTitle.text = "\(collection.name) (\(collection.nfts.count))"
        if let imageEncodedString = collection.imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let imageUrl = URL(string: imageEncodedString) {
            collectionCover.kf.setImage(with: imageUrl)
        }
    }

    private func setupView() {
        contentView.addViewWithNoTAMIC(collectionCover)
        contentView.addViewWithNoTAMIC(collectionTitle)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionCover.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            collectionCover.bottomAnchor.constraint(equalTo: collectionTitle.topAnchor, constant: -4)
        ])
    }

}
