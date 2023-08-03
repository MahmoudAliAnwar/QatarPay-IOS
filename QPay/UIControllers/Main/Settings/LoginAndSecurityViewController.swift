//
//  Login&SecurityViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginAndSecurityViewController: MainController {
    
    @IBOutlet weak var fingerPrintSwitch: UISwitch!
    @IBOutlet weak var extendSessionSwitch: UISwitch!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
}

extension LoginAndSecurityViewController {
    
    func setupView() {
        self.fingerPrintSwitch.setOn(userProfile.getUseFingerPrint(), animated: true)
        self.extendSessionSwitch.setOn(userProfile.getExtendLoginSession(), animated: true)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension LoginAndSecurityViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fingerPrintSwitchAction(_ sender: UISwitch) {
        self.configureLocalAuth(sender)
    }
    
    @IBAction func extendSessionSwitchAction(_ sender: UISwitch) {
        userProfile.saveExtendLoginSession(status: sender.isOn)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension LoginAndSecurityViewController {

    private func configureLocalAuth(_ sender: UISwitch) {
        
        if sender.isOn {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [weak self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        sender.setOn(success, animated: true)
                        self?.userProfile.saveUseFingerPrint(status: sender.isOn)
//                        if success {
//                            print("Success")
//                        } else {
//                            print("Fail")
//                            error
//                        }
                    }
                }
            } else {
//                no biometry
            }
            
        }else {
            sender.setOn(sender.isOn, animated: true)
            self.userProfile.saveUseFingerPrint(status: sender.isOn)
        }
    }
}
