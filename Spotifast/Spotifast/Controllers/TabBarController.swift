//
//  TabBarController.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation
import SwiftUI
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        self.delegate = self
    }
    
    func setupViewControllers() {
        let hvc = HomeViewController()
        hvc.title = "Home"
//        hvc.tabBarItem = UITabBarItem(title: hvc.title, image: UIImage(named: "earth"), selectedImage: UIImage(named: "earth"))
        hvc.tabBarItem = UITabBarItem(title: hvc.title, image: nil, tag: 0)
        let homeNavigation = UINavigationController(rootViewController: hvc)
        
        let favArtist = FavoriteArtistsViewController()
        favArtist.title = "🖤 Artists"
        favArtist.tabBarItem = UITabBarItem(title: favArtist.title, image: nil, selectedImage: nil)
        let favoriteArtistsNavigation = UINavigationController(rootViewController: favArtist)
        
        let favVc = FavoritesViewController()
        favVc.title = "Favorites 🎵"
        favVc.tabBarItem = UITabBarItem(title: favVc.title, image: nil, selectedImage: nil)
        let favoriteNavigation = UINavigationController(rootViewController: favVc)
        
        viewControllers = [homeNavigation, favoriteArtistsNavigation, favoriteNavigation]
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected a new view controller")
    }
}
