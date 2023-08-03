//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class PhoneBillsController: DueToPaySectionController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        changeStatusBarBG(color: .mRed)
        changeStatusBarBG(color: .clear)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
