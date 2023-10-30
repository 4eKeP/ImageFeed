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
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    
    init(from body: PhotoResult) {
        self.id = body.id
        self.size = CGSize(width: body.width, height: body.height)
        self.createdAt = makeDate(body: body)
        self.welcomeDescription = body.description
        self.thumbImageURL = body.urls.thumb
        self.largeImageURL = body.urls.raw
        self.isLiked = body.likedByUser
        
        func makeDate(body: PhotoResult) -> Date? {
            let dateFormatter = ISO8601DateFormatter()
            var finalDate: Date?
            if let date = dateFormatter.date(from: body.createdAt) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day, .month, .year], from: date)
                finalDate = calendar.date(from: components)
            } else {
                print("не удалось получить дату")
            }
            return finalDate
        }
    }
}
