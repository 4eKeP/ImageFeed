//
//  ImagesListCellDelegate.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 01.11.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
