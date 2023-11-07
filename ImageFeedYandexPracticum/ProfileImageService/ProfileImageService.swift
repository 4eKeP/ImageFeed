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
        
        let task = urlSession.objectTask(for: request) { [ weak self ] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    guard let profileImageURL = body.profileImage.small else { return }
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL" : profileImageURL])
                    
                case .failure(let error):
                    
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension ProfileImageService {
    
    private func profileRequest(token: String, username: String) -> URLRequest {
        URLRequest.makeProfileHTTPRequest(path: "/users/\(username)",
                                          httpMethod: "GET",
                                          baseURL: AuthConfiguration.standard.defaultBaseURL,
                                          token: "Bearer \(token)",
                                          headerField: "Authorization"
        )
    }
}

extension ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
}


