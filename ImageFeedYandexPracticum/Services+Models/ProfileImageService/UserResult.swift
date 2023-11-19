//
//  UserResult.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 28.10.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileURL
}

struct ProfileURL: Codable {
    let medium: String?
}
