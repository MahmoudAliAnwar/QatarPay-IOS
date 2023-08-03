//
//  HomeController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class EStoreTopupController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changeStatusBarBG()
        changeStatusBarBG(color: .clear)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
