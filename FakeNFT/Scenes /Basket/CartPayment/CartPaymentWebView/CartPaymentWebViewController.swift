//
//  CartPaymentWebViewController.swift
//  FakeNFT
//
//  Created by Andrey Bezrukov on 11.09.2023.
//

import UIKit
import WebKit

final class CartPaymentWebViewController: UIViewController {
    private let webView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    private let webViewRequest: URLRequest

    init(request: URLRequest) {
        self.webViewRequest = request
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

private extension CartPaymentWebViewController {
    func configure() {
        
        addSubviews()
        setConstraints()

        view.backgroundColor = .unWhite
        webView.load(webViewRequest)
    }

    func addSubviews() {
        view.addViewWithNoTAMIC(webView)
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
