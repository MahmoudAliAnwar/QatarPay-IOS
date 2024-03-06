//
//  BeneficiaryComingSoonViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 25/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class BeneficiaryComingSoonViewController: MainController {

    @IBOutlet weak var containerViewDesign: ViewDesign!

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

extension BeneficiaryComingSoonViewController {
    
    func setupView() {
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension BeneficiaryComingSoonViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension BeneficiaryComingSoonViewController {
    
}
