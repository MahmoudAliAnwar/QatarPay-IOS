//
//  MyBookProfileViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookProfileViewController: MyBookController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.changeStatusBarBG(color: .mKarwa_Dark_Red)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MyBookProfileViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension MyBookProfileViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MyBookProfileViewController {
    
}
