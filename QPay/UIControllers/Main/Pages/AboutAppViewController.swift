//
//  AboutAppViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/14/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class AboutAppViewController: ViewController {

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
