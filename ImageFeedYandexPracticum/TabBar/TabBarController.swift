//
//  TabBarController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 19.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: 
                "NavigationViewController"
//                "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "tab_editorial_active"),
                                                           selectedImage: nil)
        
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
