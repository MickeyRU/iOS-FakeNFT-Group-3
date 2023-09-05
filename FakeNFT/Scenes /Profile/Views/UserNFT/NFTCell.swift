import UIKit
import Cosmos

final class NFTCell: UITableViewCell, ReuseIdentifying {
    private let nftImageView = ViewFactory.shared.createNFTImageView()
    private let likeImageView = ViewFactory.shared.createLikeImageView()
    
    private let name: UILabel = {
        let label = UILabel()
        label.text = "Lilo"
        label.font = UIFont.sfBold17
        return label
    }()
    
    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.rating = 3
        view.settings.starSize = 12
        view.settings.starMargin = 2
        view.settings.filledColor = UIColor.unYellow
        view.settings.emptyBorderColor = UIColor.init(hexString: "F7F7F8")
        view.settings.filledBorderColor = UIColor.unYellow
        view.settings.updateOnTouch = false
        return view
    }()
    
    private let authorPrefix: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular15
        label.text = "от"
        return label
    }()
    
    private let author: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.text = "John Doe"
        return label
    }()
    
    private let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
        label.text = "Цена"
        label.font = UIFont.sfRegular13
        return label
    }()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold17
        label.text = "1,78 ETH"
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
        nftImageView.image = UIImage(named: "mockImage")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(image: UIImage) {
//        self .nftImageView.image = image
//    }
    
    private func setupViews() {
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
