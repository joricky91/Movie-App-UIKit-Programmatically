//
//  TabBarViewController.swift
//  Movie App UIKit Programmatically
//
//  Created by Jonathan Ricky Sandjaja on 02/02/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let movieVC = UINavigationController(rootViewController: ViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        
        movieVC.title = "Home"
        searchVC.title = "Search"
        
        self.setViewControllers([movieVC, searchVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let imagesItem = ["film", "magnifyingglass"]
        
        for item in 0...1 {
            items[item].image = UIImage(systemName: imagesItem[item])
        }
        
    }
    
}
