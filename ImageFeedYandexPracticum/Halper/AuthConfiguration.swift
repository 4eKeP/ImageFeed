//
//  AuthConfiguration.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import Foundation


     let AccessKey = "6_TdLtFxJcEiWpzVZ2p1JQI5HbW2deGanNf5fpPzpRw"
     let SecretKey = "1dFLYCytfD3ebSeUxvciOgmwi6KKHkgJ9QDwM84jhxY"
     let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
     let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
     let AccessScope = "public+read_user+write_likes"
     let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let defaultBaseURL: URL
    let accessScope: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 defaultBaseURL: DefaultBaseURL,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, defaultBaseURL: URL, accessScope: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.defaultBaseURL = defaultBaseURL
        self.accessScope = accessScope
        self.authURLString = authURLString
    }
}
