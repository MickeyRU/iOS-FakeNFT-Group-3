import UIKit
import Cosmos

final class ViewFactory {
    static let shared = ViewFactory()
    
    func createTextLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.sfBold22
        return label
    }
    
    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.sfRegular17
        textView.backgroundColor = .unLightGray
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
        return textView
    }
    
    func createNFTImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }
    
    func createLikeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyHeartButtonImage")
        return imageView
    }
    
    func createRatingView() -> CosmosView {
        let view = CosmosView()
        view.settings.starSize = 12
        view.settings.totalStars = 5
        view.settings.starMargin = 2
        view.settings.filledColor = UIColor.unYellow
        view.settings.emptyBorderColor = .unLightGray
        view.settings.filledBorderColor = UIColor.unYellow
        view.settings.updateOnTouch = false
        view.settings.filledImage = UIImage(named: "filledStarImage")
        view.settings.emptyImage = UIImage(named: "emptyStarImage")
        return view
    }
}
