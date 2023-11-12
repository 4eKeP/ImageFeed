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


protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfile(profile: Profile)
}

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
        button.accessibilityIdentifier = "LogoutButton"
        button.addTarget(self, action: #selector(logoutButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
        addProfileImageServiceObserver()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
        alert.view.accessibilityIdentifier = "Alert"
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.presenter?.cleanTokenDataAndResetToAuth()
        })
                self.present(alert, animated: true, completion: nil)
    }
    
    func addProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main)
        { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.getProfileImageUrl()
        }
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    func updateProfile(profile: Profile) {
            self.nameLabel.text = profile.name
            self.loginNameLabel.text = profile.loginName
            self.descriptionLabel.text = profile.bio
    }
}



