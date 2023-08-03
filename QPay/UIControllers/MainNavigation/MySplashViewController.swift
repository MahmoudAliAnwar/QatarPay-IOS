//
//  MySplashViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/22/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MySplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {

            let userProfile = UserProfile.shared
            
            let signInVC = self.getStoryboardView(SignInViewController.self)
            
            if userProfile.isFirstRun() {
                userProfile.saveUseFingerPrint(status: false)
                userProfile.saveExtendLoginSession(status: false)
                
                self.navigationController?.setViewControllers([signInVC], animated: true)
                
            }else {
                if userProfile.isLoggedIn() && userProfile.getUseFingerPrint() {
                    let vc = self.getStoryboardView(TouchIDViewController.self)
                    self.navigationController?.setViewControllers([vc], animated: true)
                    
                }else {
                    self.navigationController?.setViewControllers([signInVC], animated: true)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
