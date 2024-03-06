//
//  DocumentsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class DocumentsViewController: MainController {

    var document: Document!
    
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

extension DocumentsViewController {
    
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

extension DocumentsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension DocumentsViewController {
    
}
