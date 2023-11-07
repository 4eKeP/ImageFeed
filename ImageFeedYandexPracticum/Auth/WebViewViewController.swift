//
//  WebViewViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import UIKit
import WebKit

protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressHidden(_ isHidden: Bool)
    func setProgressValue(_ newValue: Float)
}



final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [], changeHandler: { [weak self] _ ,  _ in
            guard let self = self else { return }
            self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
        })
        
        webView.navigationDelegate = self
       
        presenter?.viewDidLoad()
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let item = urlComponents.queryItems,
            let codeItem = item.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
