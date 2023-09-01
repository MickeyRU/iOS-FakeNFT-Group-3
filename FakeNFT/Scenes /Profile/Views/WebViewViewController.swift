import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private var targetURL: URL
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    init(url: URL) {
        self.targetURL = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        webView.load(URLRequest(url: targetURL))
    }
    
    private func setupViews() {
        view.addViewWithNoTAMIC(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
