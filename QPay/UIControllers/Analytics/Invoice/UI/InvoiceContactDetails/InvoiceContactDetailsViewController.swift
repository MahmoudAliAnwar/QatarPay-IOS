//
//  InvoiceContactDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceContactDetailsViewController: InvoiceViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    var contact: InvoiceContact?
    
    var successSaveCallBack: ((BaseResponse) -> Void)?
    
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

extension InvoiceContactDetailsViewController {
    
    func setupView() {
        if isForDeveloping {
            self.nameTextField.text = "name"
            self.mobileTextField.text = "mobile"
            self.companyNameTextField.text = "company"
            self.emailTextField.text = "email"
            self.addressTextField.text = "address"
        }
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.saveButton.isHidden = self.contact != nil
        
        guard let cont = self.contact else { return }
        self.nameTextField.text = cont._name
        self.mobileTextField.text = cont._mobile
        self.companyNameTextField.text = cont._company
        self.emailTextField.text = cont._email
        self.addressTextField.text = cont._address
    }
}

// MARK: - ACTIONS

extension InvoiceContactDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard let name = self.nameTextField.text, name.isNotEmpty,
              let mobile = self.mobileTextField.text, mobile.isNotEmpty,
              let company = self.companyNameTextField.text, company.isNotEmpty,
              let email = self.emailTextField.text, email.isNotEmpty,
              let address = self.addressTextField.text, address.isNotEmpty else {
            self.showSuccessMessage("Please, enter the contact data")
            return
        }
        
        var contact = InvoiceContact()
        contact.name = name
        contact.mobile = mobile
        contact.company = company
        contact.email = email
        contact.address = address
        
        let builder = InvoiceEndPoints.createContact(contact: contact)
        
        self.showLoadingView(self)
        
        InvoiceRequestsService.shared.send(builder) { (result: Result<BaseResponse, InvoiceRequestErrors>) in
            switch result {
            case .success(let response):
                self.hideLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.navigationController?.popViewController(animated: true)
                    self.successSaveCallBack?(response)
                }
                break
                
            case .failure(let error):
                self.hideLoadingView(error.localizedDescription)
                break
            }
        }
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceContactDetailsViewController {
    
}
