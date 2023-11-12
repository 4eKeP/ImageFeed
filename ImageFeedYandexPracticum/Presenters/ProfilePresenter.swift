//
//  ProfilePresenter.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 11.11.2023.
//

import Foundation
import WebKit

protocol ProfilePesenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func cleanTokenDataAndResetToAuth()
    func getProfileImageUrl()
}

final class ProfilePresenter: ProfilePesenterProtocol {
    
    private var profileImageService = ProfileImageService.shared
    private var profileService = ProfileService.shared
    
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        getProfileImageUrl()
        getProfileData()
    }
    
    func cleanTokenDataAndResetToAuth() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {}
                )
            }
        }
        OAuth2TokenStorage.deleteToken()
        guard let window = UIApplication.shared.windows.first else {fatalError("окно не обноружено")}
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    func getProfileImageUrl() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
    
    func getProfileData() {
        guard let profile = profileService.profile else { return }
        view?.updateProfile(profile: profile)
    }
}
