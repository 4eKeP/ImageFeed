//
//  SplashViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 04.10.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    //: Layout properties
    private lazy var logoImageView: UIImageView = {
        var view = UIImageView()
        let profileImage = UIImage(named: "splash_screen_logo")
        view = UIImageView(image: profileImage)
        return view
    }()
    
    //: Properties
    private let authenticationSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token: token)
        } else {
            switchToAuthViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private func switchToTabBarViewController() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        guard let window = windowScenes?.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
            authVC.delegate = self
            authVC.modalPresentationStyle = .fullScreen
            present(authVC, animated: true)
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authenticationSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Faild to prepare for \(authenticationSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                fetchProfile(token: token)
                self.switchToTabBarViewController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert(message: "Не удалось войти в систему")
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = profileService.profile?.username else { return }
                fetchProfileImage(username: username, token: token)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarViewController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showErrorAlert(message: "Не удалось получить данные профиля")
            }
        }
    }
    
    private func fetchProfileImage(username: String, token: String) {
        profileImageService.fetchProfileImageURL(username: username, token: token) { result in
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//: Layout settings
extension SplashViewController {
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }
    
    private func setupViews() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.backgroundColor = .ypBlack
    }
}

