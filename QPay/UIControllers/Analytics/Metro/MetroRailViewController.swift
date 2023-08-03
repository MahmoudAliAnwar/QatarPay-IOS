//
//  MetroRailViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MetroRailViewController: MetroRailController {
    
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

extension MetroRailViewController {
    
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

extension MetroRailViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(MetroRailCardsViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func faresCardAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddTravelCardViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension MetroRailViewController {
    
}
