//
//  ProfileImageService.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 18.10.2023.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        let request = profileRequest(token: token, username: username)
        
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    guard let profileImageURL = body.profile_image.small else { return }
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL" : profileImageURL])
                    
                case .failure(let error):
                    
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
    struct UserResult: Codable {
        let profile_image: ProfileURL
    }
    
    struct ProfileURL: Codable {
        let small: String?
    }
}

extension ProfileImageService {
    
    private func profileRequest(token: String, username: String) -> URLRequest {
        URLRequest.makeProfileHTTPRequest(path: "/users/\(username)",
                                          httpMethod: "GET",
                                          baseURL: URL(string: "https://api.unsplash.com")!,
                                          token: "Bearer \(token)",
                                          headerField: "Authorization"
        )
    }
}

extension ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
}


