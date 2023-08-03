//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class ParkingsController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeStatusBarBG(color: .clear)
       // changeStatusBarBG(color: .mParkings_Light_Red)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
