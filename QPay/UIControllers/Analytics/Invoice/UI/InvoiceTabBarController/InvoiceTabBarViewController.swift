//
//  InvoiceTabBarViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.selectedIndex = 2
        
        if #available(iOS 13, *) {
            let appearance = UITabBarAppearance()
            
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .white
            
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            
            self.tabBar.standardAppearance = appearance
            
        } else {
            self.tabBar.barTintColor = .white
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.isTranslucent = false
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = .white
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set red as selected background color
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(UIColor.black.withAlphaComponent(0.5), size: tabBarItemSize).resizableImage(withCapInsets: .zero)
        
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceTabBarViewController {
    
}

