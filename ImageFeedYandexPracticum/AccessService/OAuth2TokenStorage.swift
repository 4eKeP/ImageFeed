//
//  OAuth2TokenStorage.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 04.10.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let authToken = "Auth token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: authToken)
        }
        set {
            guard let newValue = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: authToken)
            guard isSuccess else {
                return print("не удалось сохранить ключ в keyChain")
            }
        }
    }
}


