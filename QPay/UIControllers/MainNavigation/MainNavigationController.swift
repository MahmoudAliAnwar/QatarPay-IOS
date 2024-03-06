//
//  MainNavigationController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import Reachability

class MainNavigationController: UINavigationController {
    
    private var isCalledViewCycle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    @objc private func didChangeConnection(_ notification: Notification) {
        guard let reachable = notification.object as? Reachability else { return }
        
        if reachable.connection == .wifi ||
            reachable.connection == .cellular {
            self.internetSnackbar.dismiss()
            
            if !self.isCalledViewCycle {
                self.topViewController?.viewDidLoad()
                self.topViewController?.viewWillAppear(true)
                
                SnackbarBuilder.getInstance("You are reconnecting")
                    .setBackgroundColor(.systemGreen)
                    .build()
                    .show()
                
                self.isCalledViewCycle = true
            }
            
        } else {
            self.internetSnackbar.show()
            self.isCalledViewCycle = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension MainNavigationController {
    
    func setupView() {
        AppDelegate.shared.rootNavigationController = self
        
        let vc = self.getStoryboardView(MySplashViewController.self)
        self.setViewControllers([vc], animated: false)
    }
    
    func localized() {
    }
    
    func setupData() {
        
    }
    
    func fetchData() {
    }
}
