//
//  CartPaymentViewController.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 04.09.2023.
//

import UIKit

public final class CartPaymentViewController: UIViewController {
    private enum Constants {
        static let purchaseBackgroundViewHeight: CGFloat = 186
        static let userAgreementTextViewInsets = UIEdgeInsets(top: 12, left: 16, bottom: 126, right: 16)
        static let purchaseButtonInsets = UIEdgeInsets(top: 16, left: 16, bottom: 50, right: 16)
    }
    
    private lazy var currenciesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .unWhite
        collectionView.refreshControl = self.refreshControl
        collectionView.dataSource = self.collectionViewHelper
        collectionView.delegate = self.collectionViewHelper
        collectionView.register<CartPaymentCollectionViewCell>(CartPaymentCollectionViewCell.self)
        return collectionView
    }()
    
    private let purchaseBackgroundView = PurchaseBackgroundView()
    
    private lazy var userAgreementTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let normalText = "cart_payment_user_textview_text".localized
        let linkText = "cart_payment_user_textview_link_text".localized
        let link = AppConstants.Links.purchaseUserAgreement
        
        textView.addHyperLinksToText(originalText: normalText + linkText, hyperLinks: [linkText: link], lineHeight: 6)
        textView.isEditable = false
        textView.backgroundColor = .unLightGray
        textView.font = .sfRegular13
        textView.delegate = self
        return textView
    }()
    
    private lazy var purchaseButton: AppButton = {
        let button = AppButton(type: .filled, title: "cart_payment_pushase_button_title".localized)
        button.addTarget(self, action: #selector(self.didTapPurchaseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshCollection(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var collectionViewHelper: CartPaymentCollectionViewHelperProtocol?
    private let viewModel: CartPaymentViewModelProtocol
    private let router: CartPaymentRouterProtocol
    
    public init(
        collectionViewHelper: CartPaymentCollectionViewHelperProtocol,
        viewModel: CartPaymentViewModelProtocol,
        router: CartPaymentRouterProtocol
    ) {
        self.collectionViewHelper = collectionViewHelper
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        
        self.collectionViewHelper?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Actions
    
    @objc
    func didTapPurchaseButton() {
        viewModel.purсhase()
    }
    
    @objc
    func refreshCollection(_ sender: UIRefreshControl) {
        viewModel.fetchCurrencies()
        sender.endRefreshing()
    }
}

// MARK: - CartPaymentCollectionViewHelperDelegate

extension CartPaymentViewController: CartPaymentCollectionViewHelperDelegate {
    public var currencies: [CurrencyCellViewModel] {
        viewModel.currencies.value
    }
    
    public func cartPaymentCollectionViewHelper(
        _ cartPaymentCollectionViewHelper: CartPaymentCollectionViewHelper,
        didSelectCurrencyId id: String
    ) {
        viewModel.selectedCurrencyId.value = id
    }
}

// MARK: - UITextViewDelegate

extension CartPaymentViewController: UITextViewDelegate {
    public func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange
    ) -> Bool {
        router.showUserAgreementWebView(on: self, urlString: URL.absoluteString)
        return false
    }
}

// MARK: - Configure

private extension CartPaymentViewController {
    
    func configure() {
        view.backgroundColor = .unWhite
        
        addSubviews()
        setConstraints()
        bind()
        setupNavigationBar()
        
        ProgressHUDWrapper.show()
        viewModel.fetchCurrencies()
    }
    
    func setupNavigationBar() {
        let font = UIFont.sfBold17
        let textColor = UIColor.unBlack
        let titleAttributes = [NSAttributedString.Key.font: font,
                               NSAttributedString.Key.foregroundColor: textColor]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.title = "cart_payment_view_title".localized
    }
    
    func bind() {
        self.viewModel.currencies.bind { [weak self] _ in
            guard let self else { return }
            self.currenciesCollectionView.reloadData()
        }
        
        self.viewModel.cartPaymentViewState.bind { state in
            switch state {
            case .empty:
                ProgressHUDWrapper.hide()
            case .loaded:
                ProgressHUDWrapper.hide()
            case .loading:
                ProgressHUDWrapper.show()
            }
        }
        
        self.viewModel.purchaseState.bind { [weak self] purchaseState in
            guard let self, purchaseState != .didNotHappen else { return }
            
            let resultType: CartPaymentResultViewController.ResultType = purchaseState == .success ? .success : .failure
            self.router.showPaymentResult(on: self, resultType: resultType) { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                
                if resultType == .success {
                    NotificationCenterWrapper.shared.sendNotification(type: .showCatalog)
                }
            }
        }
        
        self.viewModel.error.bind { [weak self] error in
            guard let self, let error else { return }
            self.router.showErrorAlert(on: self, error: error)
        }
    }
}

// MARK: - Add subviews / Set constraints

extension CartPaymentViewController {
    
    private func addSubviews() {
        view.addViewWithNoTAMIC(currenciesCollectionView)
        view.addViewWithNoTAMIC(purchaseBackgroundView)
        
        purchaseBackgroundView.addViewWithNoTAMIC(userAgreementTextView)
        purchaseBackgroundView.addViewWithNoTAMIC(purchaseButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            currenciesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currenciesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currenciesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currenciesCollectionView.bottomAnchor.constraint(equalTo: purchaseBackgroundView.topAnchor),
            
            purchaseBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            purchaseBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            purchaseBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            purchaseBackgroundView.heightAnchor.constraint(equalToConstant: Constants.purchaseBackgroundViewHeight),
            
            userAgreementTextView.topAnchor.constraint(
                equalTo: purchaseBackgroundView.topAnchor,
                constant: Constants.userAgreementTextViewInsets.top
            ),
            userAgreementTextView.leadingAnchor.constraint(
                equalTo: purchaseBackgroundView.leadingAnchor,
                constant: Constants.userAgreementTextViewInsets.left
            ),
            userAgreementTextView.trailingAnchor.constraint(
                equalTo: purchaseBackgroundView.trailingAnchor,
                constant: -Constants.userAgreementTextViewInsets.right),
            userAgreementTextView.bottomAnchor.constraint(
                    equalTo: purchaseBackgroundView.bottomAnchor,
                    constant: -Constants.userAgreementTextViewInsets.bottom
            ),
            
            purchaseButton.topAnchor.constraint(
                equalTo: userAgreementTextView.bottomAnchor,
                constant: Constants.purchaseButtonInsets.top
            ),
            purchaseButton.leadingAnchor.constraint(
                equalTo: purchaseBackgroundView.leadingAnchor,
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
        ])
    }
}
