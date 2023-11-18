//
//  AuthConfiguration.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import Foundation


     let accessKeyConstant = "6_TdLtFxJcEiWpzVZ2p1JQI5HbW2deGanNf5fpPzpRw"
     let secretKeyConstant = "1dFLYCytfD3ebSeUxvciOgmwi6KKHkgJ9QDwM84jhxY"
     let redirectURIConstant = "urn:ietf:wg:oauth:2.0:oob"
     let defaultBaseURLConstant = URL(string: "https://api.unsplash.com")!
     let accessScopeConstant = "public+read_user+write_likes"
     let unsplashAuthorizeURLStringConstant = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let defaultBaseURL: URL
    let accessScope: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: accessKeyConstant,
                                 secretKey: secretKeyConstant,
                                 redirectURI: redirectURIConstant,
                                 defaultBaseURL: defaultBaseURLConstant,
                                 accessScope: accessScopeConstant,
                                 authURLString: unsplashAuthorizeURLStringConstant)
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
