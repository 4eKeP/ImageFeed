//
//  File.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 17.10.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}
