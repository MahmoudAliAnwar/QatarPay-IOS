//
//  PayViaCashViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PayViaCashViewController: MainController {

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
        
    }
}

extension PayViaCashViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

extension PayViaCashViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension PayViaCashViewController {
    
}
