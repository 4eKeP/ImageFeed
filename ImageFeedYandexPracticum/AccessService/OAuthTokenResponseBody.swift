//
//  OAuthTokenResponseBody.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 05.10.2023.
//

import Foundation

extension OAuth2Service {
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope = "public+read_user+write_likes"
            case createdAt = "created_at"
        }
    }
}
