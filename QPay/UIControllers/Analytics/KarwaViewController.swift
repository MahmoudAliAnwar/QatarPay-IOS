//
//  KarwaViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class KarwaBusViewController: MainController {

    override func viewDidLoad() {
        super.currentView = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
}

// MARK: - ACTIONS

extension KarwaBusViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension KarwaBusViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}
