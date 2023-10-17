//
//  ProfileService.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 16.10.2023.
//

import Foundation

final class ProfileService {
    
    
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
    //  let profileImageURL: String
        
        enum CodingKeys: String, CodingKey {
            case username = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
     //       case profileImageURL = "profile_image"
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        var bio: String
    //    let profileImageURL: URL
    }
    
    private func profileRequest() -> URLRequest {
       // let url = URL(string: "https://api.unsplash.com/me")
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com")!
        )
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
            // Создайте URL для GET-запроса /me
    //        if let url = URL(string: "https://api.unsplash.com/me") {
                var request = profileRequest()
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                // Создайте URLSession и выполните GET-запрос
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
//                    print("начало ответа \(response) конец ответа")
//                    print(String(decoding: data!, as: UTF8.self))
                    if let data = data {
       //                 print(data)
                        do {
                            // Декодируйте ответ в объект ProfileResult
                            let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
    
                            // Создайте объект Profile на основе полученных данных
                            let profile = Profile(username: profileResult.username,
                                                  name: "\(profileResult.firstName) \(profileResult.lastName)",
                                                  loginName: "@\(profileResult.username)",
                                                  bio: profileResult.bio ?? "Тут пока что пусто"
                                      //            profileImageURL: URL(string: profileResult.profileImageURL)!
                            )
    
                            completion(.success(profile))
                        } catch {
                            completion(.failure(error))
                        }
                    } else if let error = error {
                        completion(.failure(error))
                    }
                }
    
                task.resume()
       //     }
        }
}

