//
//  WebViewViewPresenterProtocol.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 07.11.2023.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    
    var authHealper: AuthHelperProtocol
    
    init(view: WebViewViewControllerProtocol? = nil, authHealper: AuthHelperProtocol) {
        self.view = view
        self.authHealper = authHealper
    }
    
    func viewDidLoad() {
        let request = authHealper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHealper.code(from: url)
    }
}
