//
//  ProfileViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 14.09.2023.
//

import UIKit


final class ProfileViewController: UIViewController {
    
    private lazy var profileImageView: UIImageView = {
        var view = UIImageView()
        let profileImage = UIImage(named: "avatar")
        view = UIImageView(image: profileImage)
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var loginNameLabel: UILabel = {
        var label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor.ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Hello, World!"
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        var button = UIButton()
        guard let logoutImage = UIImage(named: "logout_button") else {return button}
        button.setImage(logoutImage, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonDidPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
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
        print("logout pressed")
    }
}


