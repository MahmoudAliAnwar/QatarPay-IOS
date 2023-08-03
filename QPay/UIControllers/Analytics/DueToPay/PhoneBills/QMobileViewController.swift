//
//  PayOnTheGoPhoneBillsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class QMobileViewController: PhoneBillsController {
    
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var editStackView: UIStackView!
    
    @IBOutlet weak var settingsBackgroundImageView: UIImageView!
    @IBOutlet weak var settingsIconImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var editBackgroundImageView: UIImageView!
    @IBOutlet weak var editIconImageViewDesign: ImageViewDesign!
    @IBOutlet weak var editLabel: UILabel!
    
    @IBOutlet weak var fullPaymentRadioButton: CheckBox!
    @IBOutlet weak var partialPaymentRadioButton: CheckBox!
    
    @IBOutlet weak var billNameTextField: UITextField!
    @IBOutlet weak var billNameErrorImageView: UIImageView!

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberErrorImageView: UIImageView!

    @IBOutlet weak var billGroupLabel: UILabel!
    @IBOutlet weak var billGroupButton: UIButton!
    @IBOutlet weak var billGroupErrorImageView: UIImageView!

    var isFullPayment = false {
        didSet {
            self.fullPaymentRadioButton.isChecked = isFullPayment
        }
    }
    
    var isPartialPayment = false {
        didSet {
            self.partialPaymentRadioButton.isChecked = isPartialPayment
        }
    }
    
    private var buttonTypeSelected: ButtonType! {
        didSet {
            self.setViewType(to: self.buttonTypeSelected)
        }
    }
    
    private enum ButtonType {
        case Settings
        case Edit
        case Delete
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
    }
}

extension QMobileViewController {
    
    func setupView() {
        self.fullPaymentRadioButton.style = .circle
        self.partialPaymentRadioButton.style = .circle
        
        self.fullPaymentRadioButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.fullRadioBtnPressed(gesture:))))
        self.partialPaymentRadioButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.partialRadioBtnPressed(gesture:))))
        
        self.buttonTypeSelected = .Settings
        
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

extension QMobileViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func settingsAction(_ sender: UIButton) {
        self.buttonTypeSelected = .Settings
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        self.buttonTypeSelected = .Edit
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
    }
    
    @IBAction func billGroupDropDownAction(_ sender: UIButton) {
        
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
    }
}

// MARK: - PRIVATE FUNCTIONS

extension QMobileViewController {
    
    private func setViewType(to btn: ButtonType) {
        self.showSettingsView(to: btn)
        self.showEditView(to: btn)
    }

    private func showSettingsView(to btn: ButtonType) {
        let condition = btn == .Settings
        
        self.settingsStackView.isHidden = !condition
        self.settingsBackgroundImageView.isHidden = !condition
        self.settingsLabel.textColor = condition ? .white : .mDark_Red
        self.settingsIconImageView.tintColor = condition ? .white : .mDark_Red
    }
    
    private func showEditView(to btn: ButtonType) {
        let condition = btn == .Edit
        
        self.editStackView.isHidden = !condition
        self.editBackgroundImageView.isHidden = !condition
        self.editLabel.textColor = condition ? .white : .mDark_Red
        self.editIconImageViewDesign.imageTintColor = condition ? .white : .mDark_Red
    }
    
    @objc private func fullRadioBtnPressed(gesture: UIGestureRecognizer) {
        self.isFullPayment = true
        self.isPartialPayment = false
    }
    
    @objc private func partialRadioBtnPressed(gesture: UIGestureRecognizer) {
        self.isPartialPayment = true
        self.isFullPayment = false
    }
}
