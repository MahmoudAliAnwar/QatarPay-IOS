//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class KahramaaBillsController: DueToPaySectionController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changeStatusBarBG(color: UIColor(red: 4/255, green: 128/255, blue: 191/255, alpha: 1))
        changeStatusBarBG(color: .clear)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
