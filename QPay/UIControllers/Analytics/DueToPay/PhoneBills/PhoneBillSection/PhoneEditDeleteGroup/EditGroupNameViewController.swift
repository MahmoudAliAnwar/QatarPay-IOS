//
//  EditGroupNameViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/08/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol EditGroupNameViewControllerDelegate: AnyObject {
    func endEditGroupName   ( for group: Group , name : String)
}

class EditGroupNameViewController: ViewController {

    @IBOutlet weak var nameTextField  : UITextField!
    
    var group              : Group?
    var updateViewDelegate : UpdateViewElement?
    weak var delegate      : EditGroupNameViewControllerDelegate?
    var operatorType       : AddPhoneBillsCardViewController.OperatorTypes?
    var groupBillType      : GroupBillType = .phoneBill
    
    enum GroupBillType {
        
        case  phoneBill
        case  kahrmaa
        case  qatarCool
    }
    
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
        
        guard let group = self.group  else {
            self.showSnackMessage("Something went wrong")
            return
        }
        
        self.nameTextField.text = group._name
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
            self.showSnackMessage("Something went wrong")
            return
        }
        
        guard let group = self.group  else {
            self.showSnackMessage("Something went wrong")
            return
        }
        
        switch groupBillType {
            
        case .phoneBill:
            guard let operatorID = self.operatorType?.rawValue  else {
                self.showSnackMessage("Something went wrong")
                return
            }
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editPhoneGroupName(name         : name,
                                                                   operatorID   : operatorID,
                                                                   phoneGroupID : group._id , { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                
                self.showSuccessMessage(resp._message)
                self.delegate?.endEditGroupName( for: group, name: name)
            })
            break
            
        case .kahrmaa:
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editKaharmaGroupName(name  : name,
                                                                   groupID :  group._id , { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                
                self.showSuccessMessage(resp._message)
                self.delegate?.endEditGroupName( for: group, name: name)
            })
            break
            
        case .qatarCool:
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editQatarCoolGroupName(name  : name,
                                                                     groupID :  group._id , { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong")
                    return
                }
                
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                
                self.showSuccessMessage(resp._message)
                self.delegate?.endEditGroupName( for: group, name: name)
            })
            break
        }
        
        
    }
    
}

// MARK: - CUSTOM FUNCTIONS

extension EditGroupNameViewController {
    
    private func closeView(isSuccess: Bool) {
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        self.dismiss(animated: true)
    }
}
