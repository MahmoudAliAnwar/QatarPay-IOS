//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class QatarCoolController: DueToPaySectionController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // changeStatusBarBG(color: UIColor(red: 9/255, green: 51/255, blue: 90/255, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
