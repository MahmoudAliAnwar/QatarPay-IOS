//
//  ForgetPasswordViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmForgetPasswordViewController: AuthController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeStatusImageView: UIImageView!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordStatusImageView: UIImageView!
    
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmNewPasswordStatusImageView: UIImageView!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var requestID: Int?
    var updateViewElement: UpdateViewElement?
    
    var isCompletePassword = false {
        willSet {
            self.showHideNewPasswordError(action: newValue ? .hide : .show)
        }
    }
    
    var isCompleteConfirmPassword = false {
        willSet {
            self.showHideConfirmNewPasswordError(action: newValue ? .hide : .show)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension ConfirmForgetPasswordViewController {
    
    func setupView() {
        super.changeStatusBarBG(color: .clear)
        
        self.newPasswordTextField.addTarget(self,
                                            action: #selector(self.textFieldDidChange(textField:)),
                                            for: .editingChanged)
        self.confirmNewPasswordTextField.addTarget(self,
                                                   action: #selector(self.textFieldDidChange(textField:)),
                                                   for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ConfirmForgetPasswordViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(isSuccess: false)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        if self.codeTextField.text!.isEmpty {
            self.codeStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
            
        }else if self.newPasswordTextField.text!.isEmpty {
            self.codeStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
            self.isCompletePassword = false
            
        }else if self.confirmNewPasswordTextField.text!.isEmpty {
            self.codeStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
            self.isCompleteConfirmPassword = false
            
        }else {
            self.codeStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
            
            guard isCompletePassword, isCompleteConfirmPassword else { return }
            
            guard let code = self.codeTextField.text, code.isNotEmpty,
                  let password = self.newPasswordTextField.text, password.isNotEmpty,
                  let id = self.requestID else {
                return
            }
            
            self.requestProxy.requestService()?.confirmForgetPassword(requestID: id, code: code, newPassword: password) { (status, response) in
                guard status,
                      let resp = response else {
                    return
                }
                self.showSnackMessage(resp.message ?? "New Password set successfully", messageStatus: .Success)
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.closeView(isSuccess: true)
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmForgetPasswordViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .confirmForgetPassword {
            showLoadingView(self)
        }
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

extension ConfirmForgetPasswordViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField : UITextField) {
        if textField == newPasswordTextField {
            guard let password = newPasswordTextField.text,
                  password.isNotEmpty else {
                self.isCompletePassword = false
                return
            }
            
            let strength = checkPasswordStrength(password: password)
            self.isCompletePassword = strength >= 5
            
        }else if textField == confirmNewPasswordTextField {
            guard let confirmPassword = confirmNewPasswordTextField.text,
                  confirmPassword.isNotEmpty else {
                self.isCompleteConfirmPassword = false
                return
            }
            
            guard let password = self.newPasswordTextField.text,
                  password.isNotEmpty else {
                return
            }
            self.isCompleteConfirmPassword = confirmPassword == password
        }
    }
}
    
// MARK: - PRIVATE FUNCTIONS

extension ConfirmForgetPasswordViewController {
    
    private func closeView(isSuccess: Bool) {
        self.dismiss(animated: true) {
            self.updateViewElement?.elementUpdated(fromSourceView: self, status: isSuccess, data: nil)
        }
    }
    
    private func showHideNewPasswordError(action: ViewErrorsAction = .show) {

        switch action {
        case .hide:
            if !self.newPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.newPasswordErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.newPasswordErrorLabel.frame.height
                }
            }
            self.newPasswordStatusImageView.image = #imageLiteral(resourceName: "ic_succes")

        case .show:
            if self.newPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.newPasswordErrorLabel.frame.height
                    self.newPasswordErrorLabel.isHidden = false
                }
            }
            self.newPasswordStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
        }
    }
    
    private func showHideConfirmNewPasswordError(action: ViewErrorsAction = .show) {

        switch action {
        case .hide:
            if !self.confirmNewPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.confirmNewPasswordErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.confirmNewPasswordErrorLabel.frame.height
                }
            }
            self.confirmNewPasswordStatusImageView.image = #imageLiteral(resourceName: "ic_succes")

        case .show:
            if self.confirmNewPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.confirmNewPasswordErrorLabel.frame.height
                    self.confirmNewPasswordErrorLabel.isHidden = false
                }
            }
            self.confirmNewPasswordStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
        }
    }
}

