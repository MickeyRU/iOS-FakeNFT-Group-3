import UIKit
import Cosmos
import Kingfisher

final class ProfileNFTCell: UITableViewCell, ReuseIdentifying {
    private let nftImageView = ViewFactory.shared.createNFTImageView()
    private let likeImageView = ViewFactory.shared.createLikeImageView()
    private let ratingView = ViewFactory.shared.createRatingView()
    
    private let authorPrefix: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular15
        label.text = NSLocalizedString("from", comment: "")
        return label
    }()
    
    private let author: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        return label
    }()
    
    private let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing = 4
        return stackView
    }()
    
    private let nftDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Price", comment: "") 
        label.font = UIFont.sfRegular13
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(nft: ProfileNFT, authorName: String) {
        self.nftImageView.kf.setImage(with: URL(string: nft.images[0]))
        self.name.text = nft.name
        self.ratingView.rating = Double(nft.rating)
        self.author.text = authorName
        
        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: nft.price)) {
            self.currentPriceLabel.text = "\(formattedPrice) ETH"
        }
    }
    
    private func setupViews() {
        contentView.backgroundColor = .unWhite
        
        nftImageView.addViewWithNoTAMIC(likeImageView)
        [authorPrefix, author].forEach { authorStackView.addArrangedSubview($0) }
        [name, ratingView, authorStackView].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [priceLabel, currentPriceLabel].forEach { priceStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView, priceStackView].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nftDetailsStackView.trailingAnchor.constraint(equalTo: priceStackView.leadingAnchor, constant: -39),
            
            priceStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3)
        ])
    }
}
