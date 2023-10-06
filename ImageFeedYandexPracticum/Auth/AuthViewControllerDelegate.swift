//
//  AuthViewControllerDelegate.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 04.10.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
