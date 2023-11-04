//
//  Photo.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 28.10.2023.
//

import Foundation


struct Photo {
    
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: URL
        let largeImageURL: URL
        let isLiked: Bool
    
//    init(from body: PhotoResult) {
//        self.id = body.id
//        self.size = CGSize(width: body.width, height: body.height)
//        self.createdAt = makeDate(body: body)
//        self.welcomeDescription = body.description
//        self.thumbImageURL = body.urls.small
//        self.largeImageURL = body.urls.full
//        self.isLiked = body.likedByUser
//        
//        func makeDate(body: PhotoResult) -> Date? {
//            let dateFormatter = ISO8601DateFormatter()
//            var finalDate: Date?
//            if let createdAt = body.createdAt {
//                if let date = dateFormatter.date(from: createdAt) {
//                    finalDate = date
//                }
//            } else {
//                print("не удалось получить дату")
//            }
//            return finalDate
//        }
//    }
//    
//    init(id: String,
//         size: CGSize,
//         createdAt: Date?,
//         welcomeDescription: String?,
//         thumbImageURL: String,
//         largeImageURL: String,
//         isLiked: Bool) {
//        self.id = id
//        self.size = size
//        self.createdAt = createdAt
//        self.welcomeDescription = welcomeDescription
//        self.thumbImageURL = thumbImageURL
//        self.largeImageURL = largeImageURL
//        self.isLiked = isLiked
//    }
}
