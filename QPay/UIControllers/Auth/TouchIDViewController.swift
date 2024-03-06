//
//  TouchIDViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: AuthController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureLocalAuth()
        self.changeStatusBarBG(color: .clear)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension TouchIDViewController {
    
    func setupView() {
        self.imageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didTapImageView(_:)))
        )
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension TouchIDViewController {
    
    @IBAction func loginWithEmailAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SignInViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func useTouchIDAction(_ sender: UIButton) {
        self.configureLocalAuth()
    }
}

// MARK: - PRIVATE FUNCTIONS

extension TouchIDViewController {
    
    @objc
    private func didTapImageView(_ gesture: UIGestureRecognizer) {
        self.configureLocalAuth()
    }
    
    private func configureLocalAuth() {

        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
//                        print("Success")
                        self?.showHomeView()
                    } else {
//                        print("Fail")
//                        error
                    }
                }
            }
        } else {
//            no biometry
        }
    }
}
