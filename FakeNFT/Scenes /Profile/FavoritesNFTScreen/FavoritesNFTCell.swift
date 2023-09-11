import UIKit
import Cosmos

final class FavoritesNFTCell: UICollectionViewCell, ReuseIdentifying {
    private let nftImageView = ViewFactory.shared.createNFTImageView()
    private let likeImageView = ViewFactory.shared.createLikeImageView()
    private let ratingView = ViewFactory.shared.createRatingView()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular15
        return label
    }()
    
    private let nftDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nftImageView.addViewWithNoTAMIC(likeImageView)
        [name, ratingView, currentPriceLabel].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
    
    func configure() {
        self.nftImageView.image = UIImage(named: "NFT")
        self.ratingView.rating = Double(3)
        self.name.text = "Archie"

        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: 1.98)) {
            self.currentPriceLabel.text = "\(formattedPrice) ETH"
        }
    }
    
}
