//
//  URLRequestExtension.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 28.10.2023.
//

import Foundation

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL!
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    
    static func makeImageListHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL!,
        token: String,
        headerField: String
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: headerField)
        return request
    }
    
    static func makeProfileHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL!,
        token: String,
        headerField: String
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: headerField)
        return request
    }
}
