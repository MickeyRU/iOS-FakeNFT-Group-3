//
//  CartPaymentResultViewController.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 30.08.2023.
//
import UIKit

public final class CartPaymentResultViewController: UIViewController {
    public enum ResultType {
        case success
        case failure
    }
    
    private let resultType: ResultType
    
    private lazy var resultImageView: UIImageView = {
        let image: UIImage = self.resultType == .success ? .PaymentResult.success : .PaymentResult.failure
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        let text = self.resultType == .success
        ? "cart_payment_success_title_label".localized
        : "cart_payment_failure_title_label".localized
        label.text = text
        label.font = .sfBold22
        label.textColor = .unBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var resultButton: AppButton = {
        let title = self.resultType == .success
        ? "cart_payment_success_title_buttom".localized
        : "cart_payment_failure_title_buttom".localized
        
        let button = AppButton(type: .filled, title: title)
        button.addTarget(self, action: #selector(self.didTapResultButton), for: .touchUpInside)
        return button
    }()
    
    var onResultButtonAction: ActionCallback<Void>?
    
    init(resultType: ResultType) {
        self.resultType = resultType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Actions
    
    @objc func didTapResultButton() {
        self.onResultButtonAction?(())
    }
}

// MARK: - Add subviews / Set constraints

extension CartPaymentResultViewController {
    
    private enum Constants {
        static let resultImageViewInsets = UIEdgeInsets(top: 152, left: 48, bottom: 304, right: 48)
        static let resultLabelInsets = UIEdgeInsets(top: 20, left: 36, bottom: 0, right: 36)
        
        static let resultButtonInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        static let resultButtonHeight: CGFloat = 60
    }
    
    func addSubviews() {
        view.backgroundColor = .unWhite
        [resultImageView, resultLabel, resultButton].forEach{ view.addViewWithNoTAMIC($0)}
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            resultImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.resultImageViewInsets.top
            ),
            resultImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.resultImageViewInsets.left
            ),
            resultImageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.resultImageViewInsets.right
            ),
            resultImageView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.resultImageViewInsets.bottom
            ),
            
            resultLabel.topAnchor.constraint(
                equalTo: resultImageView.bottomAnchor,
                constant: Constants.resultLabelInsets.top
            ),
            resultLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.resultLabelInsets.left
            ),
            resultLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.resultLabelInsets.right
            ),
            
            resultButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.resultButtonInsets.left
            ),
            resultButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.resultButtonInsets.right
            ),
            resultButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.resultButtonInsets.bottom
            ),
            resultButton.heightAnchor.constraint(equalToConstant: Constants.resultButtonHeight)
        ])
    }
}
