//
//  ConfirmTransferViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/22/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmTransferViewController: MainController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fieldsViewDesign: ViewDesign!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qpanLabel: UILabel!
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var noqsTextField: UITextField!
    
    var transfer: Transfer?
    var parentView: UIViewController?
    
    var isCompleteCode1 = false
    var isCompleteCode2 = false
    var isCompleteCode3 = false
    var isCompleteCode4 = false
    
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
        
        self.requestProxy.requestService()?.delegate = self

        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            if status, let blnc = balance {
                self.balanceLabel.text = blnc.formatNumber()
            }
        }
        
        if let _ = self.parentView as? TransferViewController {
            self.titleLabel.text = "Transfer"
            
        }else if let _ = self.parentView as? PayViewController {
            self.titleLabel.text = "Confirm Payment"
        }
        
        guard let trans = self.transfer else { return }
        
        if let fName = trans.firstName, let lName = trans.lastName {
            self.nameLabel.text = "\(fName) \(lName)"
        }
        if let email = trans.email {
            self.emailTextField.text = email
        }
        if let mobile = trans.mobileNumber {
            self.mobileTextField.text = mobile
        }
        if let noqs = trans.amount {
            self.noqsTextField.text = noqs.description
        }
        if let qpan = trans.qpan {
            self.qpanLabel.text = "QPAN \(qpan)"
        }
        if let image = trans.profileImage {
            image.getImageFromURLString { (status, image) in
                guard status else { return }
                self.userImageView.image = image
            }
        }
    }
}

extension ConfirmTransferViewController {
    
    func setupView() {
        self.code1TextField.addTarget(self, action: #selector(self.code1FieldDidChange(textField:)), for: .editingChanged)
        self.code2TextField.addTarget(self, action: #selector(self.code2FieldDidChange(textField:)), for: .editingChanged)
        self.code3TextField.addTarget(self, action: #selector(self.code3FieldDidChange(textField:)), for: .editingChanged)
        self.code4TextField.addTarget(self, action: #selector(self.code4FieldDidChange(textField:)), for: .editingChanged)
        
        self.fieldsViewDesign.setViewCorners([.topLeft, .topRight])
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ConfirmTransferViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func submitAction(_ sender: UIButton) {
        
        guard isCompleteCode1, isCompleteCode2, isCompleteCode3, isCompleteCode4 else {
            self.showErrorMessage("Please Enter Pin")
            return
        }
        
        guard let trans = self.transfer else { return }
        
        var code = ""
        code += self.code1TextField.text!
        code += self.code2TextField.text!
        code += self.code3TextField.text!
        code += self.code4TextField.text!
        
        if let _ = self.parentView as? TransferViewController {
            
            self.requestProxy.requestService()?.confirmTransfer(trans, pinCode: code) { (status, response) in
                guard status else { return }
                if let resp = response {
                    self.showSuccessMessage(resp.message ?? "Transfer Confirmed Successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }else if let _ = self.parentView as? PayViewController {
            self.requestProxy.requestService()?.payToMerchant(trans, pinCode: code) { (status, response) in
                guard status else { return }
                if let resp = response {
                    self.showSuccessMessage(resp.message ?? "Pay Confirmed Successfully")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmTransferViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        showLoadingView(self)
    }

    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                break
            case .Failure(let errorType):
                switch errorType {
                case .Exception(let exc):
                    if showUserExceptions {
                        self.showErrorMessage(exc)
                    }
                    break
                case .AlamofireError(let err):
                    if showAlamofireErrors {
                        self.showSnackMessage(err.localizedDescription)
                    }
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension ConfirmTransferViewController {
    
    @objc func code1FieldDidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            let condition = text.count == 1
            if condition {
                code2TextField.becomeFirstResponder()
            }
            self.isCompleteCode1 = condition
        }
    }
    
    @objc func code2FieldDidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            let condition = text.count == 1
            if condition {
                code3TextField.becomeFirstResponder()
            }
            self.isCompleteCode2 = condition
        }
    }
    
    @objc func code3FieldDidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            let condition = text.count == 1
            if condition {
                code4TextField.becomeFirstResponder()
            }
            self.isCompleteCode3 = condition
        }
    }
    
    @objc func code4FieldDidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            let condition = text.count == 1
            if condition {
                self.view.endEditing(true)
            }
            self.isCompleteCode4 = condition
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension ConfirmTransferViewController {
    
}
