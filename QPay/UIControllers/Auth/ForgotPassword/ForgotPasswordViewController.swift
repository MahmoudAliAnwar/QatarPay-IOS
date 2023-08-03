//
//  ForgetPasswordViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: AuthController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailStatusImageView: UIImageView!
    
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var mobileStatusImageView: UIImageView!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var isCompleteEmail = false
    var isCompleteMobile = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension ForgotPasswordViewController {
    
    func setupView() {
        
        self.changeStatusBarBG(color: .clear)
        self.mobileTextField.delegate = self
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        self.mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ForgotPasswordViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        guard self.emailTextField.text!.isNotEmpty || self.mobileTextField.text!.isNotEmpty else {
            self.showErrorMessage("Email or Mobile field should not be blank")
            return
        }
        
        if isCompleteEmail {
            guard let email = self.emailTextField.text,
                  email.isNotEmpty else {
                return
            }
            
            self.requestProxy.requestService()?.forgetPassword(email: email) { (status, response) in
                guard status else { return }
            }
            
        }else if isCompleteMobile {
            guard let mobile = self.mobileTextField.text,
                  mobile.isNotEmpty else {
                return
            }
            
            self.requestProxy.requestService()?.forgetPassword(mobileNumber: mobile) { (status, response) in
                guard status else { return }
            }
        }
    }

    @IBAction func tryLoggingInAction(_ sender: UIButton) {
        self.backAction(sender)
    }
}

// MARK: - REQUESTS DELEGATE

extension ForgotPasswordViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .forgetPassword {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                guard request == .forgetPassword else { return }
                guard let response = data as? BaseResponse,
                      let id = response.requestID else {
                    return
                }
                self.showSnackMessage(response.message ?? "Verification Code sent", messageStatus: .Success)
                let vc = self.getStoryboardView(ConfirmForgetPasswordViewController.self)
                vc.requestID = id
                vc.updateViewElement = self
                self.present(vc, animated: true)
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

// MARK: - UPDATE VIEW ELEMENTS DELEGATE

extension ForgotPasswordViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is ConfirmForgetPasswordViewController {
            self.viewWillAppear(true)
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}


// MARK: - TEXT FIELD DELEGATE

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count <= 8
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == self.emailTextField {
            if let email = emailTextField.text, email.isNotEmpty {
                
                if isValidEmail(email) {
                    self.showHideEmailError(action: .hide)
                    
                }else {
                    self.showHideEmailError()
                }
            }else {
                self.showHideEmailError()
            }
            
        }else if textField == self.mobileTextField {
            if let mobile = mobileTextField.text, mobile.isNotEmpty {
                
                if mobile.count == 8 {
                    self.requestProxy.requestService()?.checkPhoneRegisterd(phoneNumber: mobile) { (status) in
                        if status {
                            self.showHideMobileError(action: .hide)
                            self.isCompleteMobile = true
                        }else {
                            self.showHideMobileError()
                            self.isCompleteMobile = false
                        }
                    }
                }else {
                    self.showHideMobileError()
                }
            }else {
                self.showHideMobileError()
            }
        }
    }
}
    
// MARK: - PRIVATE FUNCTIONS

extension ForgotPasswordViewController {
    
    private func showHideEmailError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.emailErrorLabel.isHidden = true
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
                    self.containerViewHeight.constant -= self.emailErrorLabel.frame.height
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.emailErrorLabel.frame.height
                    self.emailErrorLabel.isHidden = false
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
        }
    }
    
    private func showHideMobileError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.mobileErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileErrorLabel.isHidden = true
                    self.mobileStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
                    self.containerViewHeight.constant -= self.emailErrorLabel.frame.height
                    self.isCompleteMobile = self.mobileErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.mobileErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.mobileErrorLabel.frame.height
                    self.mobileErrorLabel.isHidden = false
                    self.mobileStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
                    self.isCompleteMobile = self.mobileErrorLabel.isHidden
                }
            }
        }
    }
}

