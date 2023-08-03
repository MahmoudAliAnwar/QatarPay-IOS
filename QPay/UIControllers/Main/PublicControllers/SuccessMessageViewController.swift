//
//  ErrorMessageViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class SuccessMessageViewController: ViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.messageLabel.text = self.message ?? ""
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.okAction(sender)
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
}
