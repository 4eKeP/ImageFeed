//
//  OAuth2TokenStorage.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 04.10.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}

extension OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
}
