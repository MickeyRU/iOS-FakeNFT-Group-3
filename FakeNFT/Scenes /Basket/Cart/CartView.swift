//
//  CartView.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import UIKit

final class CartView: UIView {
    
    private enum Constants {
        static let purchaseButtonInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 16)
        static let purchaseBackgroundViewHeight: CGFloat = 76
        static let labelsLeadingInset: CGFloat = 16
        static let nftCountLabelTopInset: CGFloat = 16
        static let finalCostLabelTopInset: CGFloat = 2
    }

    var onTapPurchaseButton: ActionCallback<Void>?
    var onRefreshTable: ActionCallback<Void>?

    var tableViewHelper: CartTableViewHelperProtocol? {
        didSet {
            self.cartTableView.delegate = self.tableViewHelper
            self.cartTableView.dataSource = self.tableViewHelper
        }
    }

    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .unWhite
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.refreshControl = self.refreshControl
        tableView.register<CartTableViewCell>(CartTableViewCell.self)
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshTable(_:)), for: .valueChanged)
        return refreshControl
    }()

    private let purchaseBackgroundView = PurchaseBackgroundView()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .sfRegular15
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let finalCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .unGreenUniversal
        label.font = .sfBold17
        return label
    }()

    private lazy var purchaseButton: AppButton = {
        let button = AppButton(type: .filled, title: "cart_purchase_button ".localized)
        button.addTarget(self, action: #selector(self.didTapPurchaseButton), for: .touchUpInside)
        return button
    }()

    private let placeholderView: CartPlaceholderView = {
        let view = CartPlaceholderView()
        view.isHidden = true
        return view
    }()

    private lazy var finalCostLabelWidthConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(
            item: self.finalCostLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: 80
        )
    }()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Selectors
    
    @objc func didTapPurchaseButton() {
        self.onTapPurchaseButton?(())
    }

    @objc func refreshTable(_ sender: UIRefreshControl) {
        self.onRefreshTable?(())
        sender.endRefreshing()
    }
}

// MARK: - Update Table 

extension CartView {
    func updateTableAnimated(changeset: Changeset<NFTCartCellViewModel>) {
        cartTableView.performBatchUpdates { [weak self] in
            self?.cartTableView.deleteRows(at: changeset.deletions, with: .automatic)
            self?.cartTableView.reloadRows(at: changeset.modifications, with: .automatic)
            self?.cartTableView.insertRows(at: changeset.insertions, with: .automatic)
        }
    }

    func setNftCount(_ nftCount: String) {
        nftCountLabel.text = nftCount
    }

    func setFinalOrderCost(_ cost: String) {
        finalCostLabel.text = cost
        finalCostLabelWidthConstraint.constant = self.finalCostLabel.intrinsicContentSize.width
    }

    func shouldHidePlaceholder(_ shouldHide: Bool) {
        placeholderView.isHidden = shouldHide
    }
}

// MARK: - Add subviews / Set constraints

extension CartView {
    
    private func addSubviews() {
        addViewWithNoTAMIC(cartTableView)
        addViewWithNoTAMIC(purchaseBackgroundView)
        addViewWithNoTAMIC(placeholderView)

        purchaseBackgroundView.addViewWithNoTAMIC(purchaseButton)
        purchaseBackgroundView.addViewWithNoTAMIC(nftCountLabel)
        purchaseBackgroundView.addViewWithNoTAMIC(finalCostLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cartTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cartTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: purchaseBackgroundView.topAnchor),

            purchaseBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            purchaseBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            purchaseBackgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            purchaseBackgroundView.heightAnchor.constraint(equalToConstant: Constants.purchaseBackgroundViewHeight),

            nftCountLabel.topAnchor.constraint(
                equalTo: purchaseBackgroundView.topAnchor,
                constant: Constants.nftCountLabelTopInset
            ),
            nftCountLabel.leadingAnchor.constraint(
                equalTo: purchaseBackgroundView.leadingAnchor,
                constant: Constants.labelsLeadingInset
            ),

            finalCostLabel.topAnchor.constraint(
                equalTo: nftCountLabel.bottomAnchor,
                constant: Constants.finalCostLabelTopInset
            ),
            finalCostLabel.leadingAnchor.constraint(
                equalTo: purchaseBackgroundView.leadingAnchor,
                constant: Constants.labelsLeadingInset),finalCostLabelWidthConstraint,

            purchaseButton.topAnchor.constraint(
                equalTo: purchaseBackgroundView.topAnchor,
                constant: Constants.purchaseButtonInsets.top
            ),
            purchaseButton.leadingAnchor.constraint(
                equalTo: finalCostLabel.trailingAnchor,
                constant: Constants.purchaseButtonInsets.left
            ),
            purchaseButton.trailingAnchor.constraint(
                equalTo: purchaseBackgroundView.trailingAnchor,
                constant: -Constants.purchaseButtonInsets.right
            ),
            purchaseButton.bottomAnchor.constraint(
                equalTo: purchaseBackgroundView.bottomAnchor,
                constant: -Constants.purchaseButtonInsets.bottom
            ),

            placeholderView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
