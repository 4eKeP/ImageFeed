//
//  ProfileViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 14.09.2023.
//

import UIKit
import Kingfisher
import WebKit
import SwiftKeychainWrapper


final class ProfileViewController: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        var view = UIImageView()
        let profileImage = UIImage(named: "placeholder")
        view = UIImageView(image: profileImage)
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = UIColor.ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        var button = UIButton()
        guard let logoutImage = UIImage(named: "logout_button") else {return button}
        button.setImage(logoutImage, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main)
        { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        guard let profile = profileService.profile else { return }
        updateProfile(profile: profile)
        
    }
    
    private func updateAvatar() {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func updateProfile(profile: Profile) {
        DispatchQueue.main.async {
            self.nameLabel.text = profile.name
            self.loginNameLabel.text = profile.loginName
            self.descriptionLabel.text = profile.bio
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupViews() {
        [profileImageView,
         nameLabel,
         loginNameLabel,
         descriptionLabel,
         logoutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    @objc
    private func logoutButtonDidPressed() {
        logoutAlert()
    }
    
    private func logoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.cleanTokenDataAndResetToAuth()
        })
                self.present(alert, animated: true, completion: nil)
    }
    
    private func cleanTokenDataAndResetToAuth() {
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
}



