//
//  AuthController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class AuthController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStatusBarBG(color: .white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    public func showHomeView() {
        let vc = Views.HomeViewController.storyboardView
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
