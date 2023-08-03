//
//  StocksControllerViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class StocksController: ViewController {
    
    var stockUpColor: UIColor = .stockUpGreen
    var stockDownColor: UIColor = .stockDownRed
    var stockUnchangedColor: UIColor = .stockUnchangedGray
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
