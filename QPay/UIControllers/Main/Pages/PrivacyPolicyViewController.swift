//
//  PrivacyPolicyViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
