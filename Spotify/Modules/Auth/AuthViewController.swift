//
//  AuthViewController.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    // MARK: - Properties
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hundleWebUrl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    // MARK: - Private methods
    
    private func hundleWebUrl() {
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func setupView() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // exchange the code for access token
        guard let url = webView.url else { return }
        let component = URLComponents(string: url.absoluteString)
        
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        print("Code: \(code)")
    }
}
