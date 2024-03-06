//
//  SelectBeneficiaryPopupViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 25/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

protocol SelectBeneficiaryPopupDelegate: AnyObject {
    func didSelectBeneficiary(_ beneficiary: Beneficiary)
}

class SelectBeneficiaryPopupViewController: ViewController {
    static let identifier = String(describing: SelectBeneficiaryPopupViewController.self)
    
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var beneficiaryNameLabel: UILabel!
    @IBOutlet weak var beneficiaryDropDownButton: UIButton!
    
    var beneficiaries = [Beneficiary]()
    var mobile: String?
    
    weak var delegate: SelectBeneficiaryPopupDelegate?
    
    private let beneficiaryDropDown = DropDown()
    private var beneficiarySelectedIndex: Int = -1
    
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

extension SelectBeneficiaryPopupViewController {
    
    func setupView() {
        self.setupDropDownAppearance()
        self.setupBeneficiaryDropDown()
        
        if let mbl = self.mobile {
            self.messageLabel.text = "There are multiple accounts using the number +974 \(mbl.inserting(separator: "-", every: 4)). Please select one account to continue with the transaction."
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SelectBeneficiaryPopupViewController {
    
    @IBAction func usersDropDownAction(_ sender: UIButton) {
        self.beneficiaryDropDown.show()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        
        if self.beneficiarySelectedIndex >= 0 {
            let ben = self.beneficiaries[self.beneficiarySelectedIndex]
            self.dismiss(animated: true) {
                self.delegate?.didSelectBeneficiary(ben)
            }
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension SelectBeneficiaryPopupViewController {
    
    private func setupDropDownAppearance() {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 36
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
    
    private func setupBeneficiaryDropDown() {
        self.beneficiaryDropDown.anchorView = self.beneficiaryDropDownButton
        
        self.beneficiaryDropDown.topOffset = CGPoint(x: 0, y: self.beneficiaryDropDownButton.bounds.height)
        self.beneficiaryDropDown.direction = .any
        self.beneficiaryDropDown.dismissMode = .automatic
        
        self.beneficiaries.forEach({ self.beneficiaryDropDown.dataSource.append($0._fullName) })
        
        self.selectBeneficiary(0)
        
        self.beneficiaryDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectBeneficiary(index)
        }
    }
    
    private func selectBeneficiary(_ index: Int) {
        self.beneficiaryDropDown.selectRow(index)
        self.beneficiaryNameLabel.text = self.beneficiaries[index]._fullName
        self.beneficiarySelectedIndex = index
    }
}
