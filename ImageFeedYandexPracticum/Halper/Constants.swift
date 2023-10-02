//
//  Constants.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import Foundation

enum Constants {
    static let AccessKey = "6_TdLtFxJcEiWpzVZ2p1JQI5HbW2deGanNf5fpPzpRw"
    static let SecretKey = "1dFLYCytfD3ebSeUxvciOgmwi6KKHkgJ9QDwM84jhxY"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")
    static let AccessScope = "public+read_user+write_likes"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
