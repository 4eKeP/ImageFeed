//
//  AuthViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private let segueToLoginScreenName = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToLoginScreenName {
            guard let webViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(segueToLoginScreenName)") }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
