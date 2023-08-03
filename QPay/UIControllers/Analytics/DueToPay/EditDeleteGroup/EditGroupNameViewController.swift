//
//  EditGroupNameViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/08/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditGroupNameViewController: ViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    var updateViewDelegate: UpdateViewElement?
    
    var operatorType: AddPhoneBillsCardViewController.OperatorTypes?
    var group : Group?
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

extension EditGroupNameViewController {
    
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

extension EditGroupNameViewController {
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.closeView(isSuccess: false)
    }
    
    @IBAction func editNameAction(_ sender: UIButton) {
        guard let name = self.nameTextField.text,
              name.isNotEmpty  else {
            self.showSnackMessage("Something went wrong",messageStatus: .Error)
            return
        }
        guard let group = self.group else {return}
        
        self.requestProxy.requestService()?.editPhoneGroupName(name: name, operatorID: self.operatorType?.rawValue ?? 0, phoneGroupID: group._id , { baseResponse in
            guard let resp = baseResponse else {return}
            
            guard resp._success else {
                self.showErrorMessage(resp._message)
                return
            }
            self.showSuccessMessage(resp._message
            )
        })
    }
    
}

// MARK: - CUSTOM FUNCTIONS

extension EditGroupNameViewController {
    
    private func closeView(isSuccess: Bool) {
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        self.dismiss(animated: true)
    }
}
