import UIKit
import Cosmos
import Kingfisher

final class FavoritesNFTCell: UICollectionViewCell, ReuseIdentifying {
    private let nftImageView = ViewFactory.shared.createNFTImageView()
    private let ratingView = ViewFactory.shared.createRatingView()
    
    private let likeImageView: UIImageView = {
        let imageview = ViewFactory.shared.createLikeImageView()
        imageview.image = UIImage(named: "filledHeartButtonImage")
        return imageview
    }()
    
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
    
    func configure(with nft: NFT) {
        self.nftImageView.kf.setImage(with: URL(string: nft.images[0] ))
        self.ratingView.rating = Double(nft.rating)
        self.name.text = nft.name

        if let formattedPrice = NumberFormatter.defaultPriceFormatter.string(from: NSNumber(value: nft.price)) {
            self.currentPriceLabel.text = "\(formattedPrice) ETH"
        }
    }
    
    private func setupViews() {
        nftImageView.addViewWithNoTAMIC(likeImageView)
        [name, ratingView, currentPriceLabel].forEach { nftDetailsStackView.addArrangedSubview($0) }
        [nftImageView, nftDetailsStackView].forEach { contentView.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalTo: nftImageView.heightAnchor),
            
            nftDetailsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftDetailsStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
}
