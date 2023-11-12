//
//  ImageListTest.swift
//  ImageFeedYandexPracticumTests
//
//  Created by admin on 12.11.2023.
//

import XCTest
import Foundation

@testable import ImageFeedYandexPracticum

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeedYandexPracticum.ImagesListViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var updateTableViewAnimatedCalled = false
    var fetchPhotosCalled = false
    
    var calcHeightForRowAtCalled = false
    var calcHeightForRowAtIndex = false
    
    var chekIfNextPageNeededCalled = false
    var chekIfNextPageNeededAtIndex = false
    
    var imagesListCellDidTapLikeCalled = false
    var imagesListCellDidTapLikeAtIndex = false
    
    var returnPhotoCalled = false
    var returnPhotoAtIndex = false
    
    var photosCount = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func fetchPhotos() {
        fetchPhotosCalled = true
    }
    
    func calculateHeightForRow(indexPath: IndexPath) -> CGFloat {
        calcHeightForRowAtCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            calcHeightForRowAtIndex = true
        }
        return CGFloat(1)
    }
    
    func chekIfNextPageNeeded(indexPath: IndexPath) {
        chekIfNextPageNeededCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            chekIfNextPageNeededAtIndex = true
        }
    }
    
    func imagesListCellDidTapLike(_ cell: ImageFeedYandexPracticum.ImagesListCell, indexPath: IndexPath) {
        imagesListCellDidTapLikeCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            imagesListCellDidTapLikeAtIndex = true
        }
    }
    
    func returnPhoto(indexPath: IndexPath) -> ImageFeedYandexPracticum.Photo {
        returnPhotoCalled = true
        if indexPath == IndexPath(row: 1, section: 0) {
            returnPhotoAtIndex = true
        }
        return Photo.init(id: "test", size: CGSize(), createdAt: Date(), welcomeDescription: "test", thumbImageURL: URL(string: "https://www.google.com")!, largeImageURL: URL(string: "https://www.google.com")!, isLiked: false)
    }
}

final class ImagesListViewTests: XCTestCase {
    let viewController = ImagesListViewController()
    let presenter = ImagesListViewPresenterSpy()
    let indexPath = IndexPath(row: 1, section: 0)
    
    func testViewDidLoadCalled() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpdateTableViewAnimated() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.updateTableViewAnimated()
        
        XCTAssertTrue(presenter.updateTableViewAnimatedCalled)
    }
    
    func testFetchPhotos() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.fetchPhotos()
        
        XCTAssertTrue(presenter.fetchPhotosCalled)
    }
    
    func testCalculateHeightForRow() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        let result = presenter.calculateHeightForRow(indexPath: indexPath)
        
        XCTAssertTrue(presenter.calcHeightForRowAtCalled)
        XCTAssertTrue(presenter.calcHeightForRowAtIndex)
        XCTAssertEqual(result, CGFloat(1))
    }
    
    func testChekIfNextPageNeeded() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.chekIfNextPageNeeded(indexPath: indexPath)
        
        XCTAssertTrue(presenter.chekIfNextPageNeededCalled)
        XCTAssertTrue(presenter.chekIfNextPageNeededAtIndex)
    }
    
    func testImagesListCellDidTapLike() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        presenter.imagesListCellDidTapLike(ImagesListCell(), indexPath: indexPath)
        
        XCTAssertTrue(presenter.imagesListCellDidTapLikeCalled)
        XCTAssertTrue(presenter.imagesListCellDidTapLikeAtIndex)
    }
    
    func testReturnPhoto() {
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        let result = presenter.returnPhoto(indexPath: indexPath)
        
        XCTAssertTrue(presenter.returnPhotoCalled)
        XCTAssertTrue(presenter.returnPhotoAtIndex)
    }
}
