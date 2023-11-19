//
//  ProfileService.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 16.10.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastData: Data?
    private(set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        let request = profileRequest(token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(from: body)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension ProfileService {
    private func profileRequest(token: String) -> URLRequest {
        URLRequest.makeProfileHTTPRequest(path: "/me",
                                          httpMethod: "GET",
                                          baseURL: AuthConfiguration.standard.defaultBaseURL,
                                          token: "Bearer \(token)",
                                          headerField: "Authorization"
        )
    }
}



