//
//  File.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 05.10.2023.
//

import Foundation

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
