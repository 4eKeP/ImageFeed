//
//  Profile.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 17.10.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    var bio: String
    
    init(from body: ProfileResult) {
        self.username = body.username
        self.name = "\(body.firstName) \(body.lastName)"
        self.loginName = "@\(body.username)"
        self.bio = body.bio ?? "Тут пока что пусто"
    }
}
