//
//  Constants.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.10.2023.
//

import Foundation

enum Constants {
    static let accessKey = "6_TdLtFxJcEiWpzVZ2p1JQI5HbW2deGanNf5fpPzpRw"
    static let secretKey = "1dFLYCytfD3ebSeUxvciOgmwi6KKHkgJ9QDwM84jhxY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let accessScope = "public+read_user+write_likes"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
