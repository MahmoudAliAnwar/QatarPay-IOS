//
//  MyBookTabBarController.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.selectedIndex = 2
        self.tabBar.unselectedItemTintColor = .systemGray4
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
