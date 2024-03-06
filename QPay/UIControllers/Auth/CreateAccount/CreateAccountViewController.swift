//
//  CreateAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreateAccountViewController: AuthController {
    
    @IBOutlet weak var merchantView: UIView!
    @IBOutlet weak var merchantCheckedView: UIView!
    
    @IBOutlet weak var qatarView: UIView!
    @IBOutlet weak var qatarCheckedView: UIView!
    
    var selectedType: AccountType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension CreateAccountViewController {
    
    func setupView() {
        setToggleBtn()
        
        self.changeStatusBarBG(color: .clear)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CreateAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SignUpViewController.self)
        userProfile.saveAccountType(type: selectedType)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func merchantAction(_ sender: UIButton) {
        setToggleBtn(type: .merchant)
    }

    @IBAction func qatarPayAction(_ sender: UIButton) {
        setToggleBtn(type: .qatarPay)
    }
}

// MARK: - ACTIONS

extension CreateAccountViewController {

    private func setToggleBtn(type: AccountType = .merchant) {
        
        switch type {
        case .admin:
            break
        case .merchant:
            self.selectedType = .merchant
            UIView.animate(withDuration: 0.3) {
                self.merchantView.backgroundColor = .systemGray5
                self.merchantCheckedView.isHidden = false
                
                self.qatarView.backgroundColor = .clear
                self.qatarCheckedView.isHidden = true
            }
            
        case .qatarPay:
            self.selectedType = .qatarPay
            UIView.animate(withDuration: 0.3) {
                self.qatarView.backgroundColor = .systemGray5
                self.qatarCheckedView.isHidden = false
                
                self.merchantView.backgroundColor = .clear
                self.merchantCheckedView.isHidden = true
            }
        }
    }
}
