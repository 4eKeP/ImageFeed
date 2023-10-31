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
    
    func fetchPhotosNextPage(
        token: String,
        completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
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
                        decodedPhotos.append(Photo(from: photo))
                    }
                    self.photos.append(contentsOf: decodedPhotos)
                    completion(.success(decodedPhotos))
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["Photos" : decodedPhotos])
                case .failure(let error):
                    print("Не удалось получить данные из запроса")
                    completion(.failure(error))
                }
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



