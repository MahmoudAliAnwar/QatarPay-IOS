//
//  NotificationsSettingsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/29/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class NotificationsSettingsViewController: MainController {
    
    @IBOutlet weak var fingerPrintSwitch: UISwitch!
    
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

extension NotificationsSettingsViewController {
    
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

extension NotificationsSettingsViewController {

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func extendSessionSwitchAction(_ sender: UISwitch) {
        
        userProfile.saveExtendLoginSession(status: sender.isOn)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension NotificationsSettingsViewController {
    
}
