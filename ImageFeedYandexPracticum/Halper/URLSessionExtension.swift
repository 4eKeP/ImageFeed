//
//  URLSessionExtension.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 19.10.2023.
//

import Foundation

extension URLSession {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        //   urlSession: URLSession,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return self.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                //          print(String(decoding: data, as: UTF8.self))
                Result { try decoder.decode(T.self, from: data) }
            }
            //      print(response)
            completion(response)
        }
    }
}
