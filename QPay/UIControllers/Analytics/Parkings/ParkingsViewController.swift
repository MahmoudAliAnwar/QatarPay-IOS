//
//  ParkingViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ParkingsViewController: ParkingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.changeStatusBarBG(color: .mParkings_Dark_Red)
    }
}

extension ParkingsViewController {
    
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

extension ParkingsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payYourParkingAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(ParkingsLocationViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func otherServicesAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Coming Soon...", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension ParkingsViewController {
    
}
