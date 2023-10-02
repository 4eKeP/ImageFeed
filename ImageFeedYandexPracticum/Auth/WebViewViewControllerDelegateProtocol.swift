//
//  WebViewViewControllerDelegateProtocol.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 02.10.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
