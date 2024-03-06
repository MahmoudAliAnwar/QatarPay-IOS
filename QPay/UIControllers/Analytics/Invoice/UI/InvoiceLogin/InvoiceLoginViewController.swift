//
//  InvoiceLoginViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceLoginViewController: InvoiceViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension InvoiceLoginViewController {
    
    func setupView() {
        if isForDeveloping {
            self.usernameTextField.text = "qmobile"
            self.passwordTextField.text = "o!4NAn$2@Q"
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InvoiceLoginViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let username = self.usernameTextField.text, username.isNotEmpty,
              let password = self.passwordTextField.text, password.isNotEmpty else {
            return
        }
        
        self.showLoadingView(self)
        let builder = InvoiceEndPoints.login(username: username, password: password)
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<InvoiceUser, InvoiceRequestErrors>) in
            switch result {
            case .success(let user):
                self.hideLoadingView()
                
                self.userProfile.invoiceUser = user
                
                let vc = self.getStoryboardView(InvoiceTabBarViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceLoginViewController {
    
}
