//
//  ImagesListService.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 23.10.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private let perPage = 10
    private let orderBy = "latest"
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    func fetchPhotosNextPage() {
            
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = oauth2TokenStorage.token else { return }
        
        let request = ImageListRequest(
            token: token,
            nextPage: nextPage)
        
        let task = urlSession.objectTask(for: request) { [ weak self ] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    self.lastLoadedPage = nextPage
                    let photosFromResponce = body
                    var decodedPhotos: [Photo] = []
                    photosFromResponce.forEach { photo in
                        decodedPhotos.append(photo.asDomain())
                    }
                    print(photosFromResponce)
                    self.photos.append(contentsOf: decodedPhotos)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["Photos" : decodedPhotos])
                case .failure(let error):
                    print("Не удалось получить данные из запроса \(error)")
                }
                self.task = nil
            }
        }
        task.resume()
    }
}

extension ImagesListService {
    
    private func ImageListRequest(token: String, nextPage: Int) -> URLRequest {
        URLRequest.makeImageListHTTPRequest(path: "/photos"
                                            + "?client_id=\(Constants.accessKey)"
                                            + "&&page=\(nextPage)",
                                            httpMethod: "GET",
                                            token: token,
                                            headerField: "Authorization")
    }
}

extension ImagesListService {
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
}

//like handling

extension ImagesListService {
    func changeLike(photoId: String, token: String, isLike: Bool, _ completion: @escaping (Result<LikeResult, Error>) -> Void) {
        let request = likeRequest(token: token, photoId: photoId, isLike: isLike)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    DispatchQueue.main.async {
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        completion(result)
                    }
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func likeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest {
        URLRequest.makeImageListHTTPRequest(path: "/photos/\(photoId)/like",
                                            httpMethod: !isLike ? "POST" : "DELETE",
                                            token: token,
                                            headerField: "Authorization")
    }
}


