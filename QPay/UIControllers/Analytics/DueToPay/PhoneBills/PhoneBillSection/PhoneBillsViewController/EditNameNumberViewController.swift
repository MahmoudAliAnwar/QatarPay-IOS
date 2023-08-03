//
//  EditNameNumberViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class EditNameNumberViewController: ViewController {
    
    @IBOutlet weak var nameTextField: UITextField!

    var updateViewDelegate: UpdateViewElement?
    var number            : PhoneNumber?
    var kaharmaNumber     : KahramaaNumber?
    var qatarCoolNumber   : QatarCoolNumber?
    var type : _Type       = .phoneBill
    
    
    enum _Type {
        case phoneBill
        case kaharmaBill
        case qatarCoolBill
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

extension EditNameNumberViewController {
    
    func setupView() {
        switch type {
            
        case .phoneBill:
            guard let name = self.number?._subscriberName else {return}
            self.nameTextField.text = name
            break
            
        case .kaharmaBill:
            
            guard let name = self.kaharmaNumber?._subscriberName else {return}
            self.nameTextField.text = name
            break
            
        case .qatarCoolBill:
            guard let name = self.qatarCoolNumber?._subscriberName else {return}
            self.nameTextField.text = name
            break
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

extension EditNameNumberViewController {
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.closeView(isSuccess: false)
    }
    
    @IBAction func editNameAction(_ sender: UIButton) {
        guard let name = self.nameTextField.text,
              name.isNotEmpty  else {
            self.showSnackMessage("Something went wrong",messageStatus: .Error)
            return
        }
        
        switch type {
            
        case .phoneBill:
          
            guard let phone = self.number else {
                self.showSnackMessage("Something went wrong",messageStatus: .Error)
                return}
            
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editPhoneBillName(name: name, operatorID: phone._operatorID, phoneGroupID: phone._numberID, { baseResponse in
                
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong",messageStatus: .Error)
                    return
                }
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message)
            })
            
        case .kaharmaBill:
            
            guard let kahramNumber = self.kaharmaNumber else {
                self.showSnackMessage("Something went wrong",messageStatus: .Error)
                return}
            
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editKaharmaName(name: name ,  id: kahramNumber._id, { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong",messageStatus: .Error)
                    return
                }
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message
               )
            })
            
        case .qatarCoolBill:
            guard let qatarCoolNumber = self.qatarCoolNumber else {
                self.showSnackMessage("Something went wrong",messageStatus: .Error)
                return
            }
            
            self.showLoadingView(self)
            self.requestProxy.requestService()?.editQatarCoolName(name: name ,  id: qatarCoolNumber._numberID, { baseResponse in
                self.hideLoadingView()
                guard let resp = baseResponse else {
                    self.showSnackMessage("Something went wrong",messageStatus: .Error)
                    return
                }
                guard resp._success else {
                    self.showErrorMessage(resp._message)
                    return
                }
                self.showSuccessMessage(resp._message
                )
            })
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension EditNameNumberViewController {
    
    private func closeView(isSuccess: Bool) {
        self.updateViewDelegate?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        self.dismiss(animated: true)
    }
}
