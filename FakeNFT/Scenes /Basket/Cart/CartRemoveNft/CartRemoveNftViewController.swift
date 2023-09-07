//
//  CartRemoveNftViewController.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import UIKit

public final class CartRemoveNftViewController: UIViewController {
    public enum RemoveNftFlow {
        case remove
        case cancel
    }
    
    private enum Constants {
        static let nftImageViewCornerRadius: CGFloat = 12
        static let nftImageViewTopInset: CGFloat = 244
        static let nftImageViewSideInset: CGFloat = 133
        
        static let removeNftLabelTopInset: CGFloat = 12
        static let removeNftLabelSideInset: CGFloat = 97
        
        static let buttonsTopInset: CGFloat = 20
        static let buttonsSideInset: CGFloat = 56
        static let buttonsSpacing: CGFloat = 8
        static let buttonsHeight: CGFloat = 44
    }
    
    var onChoosingRemoveNft: ActionCallback<RemoveNftFlow>?
    
    private let blurredEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.nftImageViewCornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let removeNftLabel: UILabel = {
        let label = UILabel()
        label.text = "cart_remove_nft_text".localized
        label.textAlignment = .center
        label.font = .sfRegular13
        label.textColor = .unBlack
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var removeNftButton: AppButton = {
        let button = AppButton(type: .nftCartRemove, title: "cart_remove_nft_button_title".localized)
        button.addTarget(self, action: #selector(self.didTapRemoveNftButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: AppButton = {
        let button = AppButton(type: .nftCartCancel, title: "cart_remove_nft_cancel_button_title".localized)
        button.addTarget(self, action: #selector(self.didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    init(nftImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.nftImageView.image = nftImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Selector
    
    @objc func didTapRemoveNftButton() {
        self.onChoosingRemoveNft?(.remove)
    }
    
    @objc func didTapCancelButton() {
        self.onChoosingRemoveNft?(.cancel)
    }
}

// MARK: - Add subviews / Set constraints

extension CartRemoveNftViewController {
    
    private func addSubviews() {
        view.backgroundColor = .clear
        [blurredEffectView, nftImageView, removeNftLabel,
         removeNftButton, cancelButton].forEach{ view.addViewWithNoTAMIC($0)}
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            blurredEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: Constants.nftImageViewTopInset),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: Constants.nftImageViewSideInset),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -Constants.nftImageViewSideInset),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            removeNftLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor,constant: Constants.removeNftLabelTopInset),
            removeNftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: Constants.removeNftLabelSideInset),
            removeNftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -Constants.removeNftLabelSideInset),
            
            removeNftButton.topAnchor.constraint(equalTo: removeNftLabel.bottomAnchor,constant: Constants.buttonsTopInset),
            removeNftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: Constants.buttonsSideInset),
            removeNftButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor,constant: -Constants.buttonsSpacing),
            removeNftButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            removeNftButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight),
            
            cancelButton.topAnchor.constraint(equalTo: removeNftButton.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -Constants.buttonsSideInset),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonsHeight)
        ])
    }
}
