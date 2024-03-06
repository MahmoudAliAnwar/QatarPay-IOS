//
//  InvoiceLogoutViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 14/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceLogoutViewController: InvoiceViewController {
    
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

extension InvoiceLogoutViewController {
    
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

extension InvoiceLogoutViewController {
    
    @IBAction func logoutAction(_ sender: UIButton) {
        self.navigationController?.popTo(InvoiceLoginViewController.self)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceLogoutViewController {
    
}
