//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 31.08.2023.
//

import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell, ReuseIdentifying {
    private var collectionCover: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var collectionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        label.textColor = .unBlack
        return label
    }()

    var viewModel: CatalogCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            collectionTitle.text = viewModel.collectionTitle
            if let imageEncodedString = viewModel.imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
                let imageUrl = URL(string: imageEncodedString) {
                collectionCover.kf.setImage(with: imageUrl)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
          super.layoutSubviews()
          let bottomSpace: CGFloat = 8.0
          contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0)
          )
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
            collectionCover.heightAnchor.constraint(equalToConstant: 140),
            collectionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            collectionCover.bottomAnchor.constraint(equalTo: collectionTitle.topAnchor, constant: -4)
        ])
    }
}
