//
//  AuthorWebViewController.swift
//  FakeNFT
//
//  Created by Никита Чагочкин on 12.09.2023.
//

import UIKit
import WebKit
import ProgressHUD

class AuthorWebViewController: UIViewController {

    private lazy var webView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        return webView
    }()

    private let viewModel: AuthorWebViewModelProtocol

    init(viewModel: AuthorWebViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .unWhite
        setupNavigationItem()
        setupView()
        setupConstraints()

        bind()
        viewModel.initialize(url: URL(string: "https://practicum.yandex.ru/ios-developer/"))
    }

    private func bind() {
        viewModel.urlObserve.bind { [weak self] url in
            guard let self = self, let url = url else { return }
            self.webView.load(URLRequest(url: url))
            self.viewModel.setPageIsLoaded(status: false)
        }

        viewModel.pageIsLoadedObserve.bind { [weak self] newValue in
            newValue ? ProgressHUD.dismiss() : ProgressHUD.show()
        }
    }

    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - WebView
extension AuthorWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.setPageIsLoaded(status: true)
    }
}

// MARK: - UI
private extension AuthorWebViewController {
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        barItem.tintColor = .unBlack
        navigationItem.leftBarButtonItem = barItem
    }

    func setupView() {
        view.addViewWithNoTAMIC(webView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
