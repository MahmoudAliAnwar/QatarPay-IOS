//
//  FirstScreenViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension FirstScreenViewController {
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createCVAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(EditPersonalResumeViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SearchCvViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
