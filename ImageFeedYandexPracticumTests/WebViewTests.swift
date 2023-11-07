//
//  ImageFeedYandexPracticumTests.swift
//  ImageFeedYandexPracticumTests
//
//  Created by admin on 07.11.2023.
//

import XCTest
import Foundation

@testable import ImageFeedYandexPracticum


final class WebViewPresenterSpy: WebViewPresenterProtocol {
   
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class ImageFeedYandexPracticumTests: XCTestCase {
    
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //зовем view
        _ = viewController.view
        
        XCTAssert(presenter.viewDidLoadCalled)
    }
    
}
