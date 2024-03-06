//
//  ContactsUsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ContactsUsViewController: MainController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.changeStatusBarBG(color: .clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
    }
}

// MARK: - ACTIONS

extension ContactsUsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailAction(_ sender: UIButton) {
        
        if let url = URL(string: "mailto:info@qatarpay.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func mobileAction(_ sender: UIButton) {
        
        if let url = URL(string: "tel:9743104001") {
            UIApplication.shared.open(url, options: [:])
        }
    }

    @IBAction func websiteAction(_ sender: UIButton) {
        
        if let url = URL(string: "https://www.qatarpay.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
