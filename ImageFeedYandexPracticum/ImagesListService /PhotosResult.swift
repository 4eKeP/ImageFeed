//
//  PhotoResult.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 28.10.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Double
    let height: Double
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct LikeResult: Codable {
    let photo: PhotoResult
}

