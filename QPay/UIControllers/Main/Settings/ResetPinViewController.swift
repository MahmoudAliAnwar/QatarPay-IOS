//
//  ResetPinViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ResetPinViewController: ViewController {
    
    @IBOutlet weak var oldPinContainerView: UIView!
    @IBOutlet weak var oldPinTextField: UITextField!
    @IBOutlet weak var oldPinErrorLabel: UILabel!
    @IBOutlet weak var showHideOldPinBtn: UIButton!
    @IBOutlet weak var oldPinBottomView: UIView!
    
    @IBOutlet weak var newPinTextField: UITextField!
    @IBOutlet weak var newPinErrorLabel: UILabel!
    @IBOutlet weak var showHideNewPinBtn: UIButton!
    @IBOutlet weak var newPinBottomView: UIView!
    
    @IBOutlet weak var confirmNewPinTextField: UITextField!
    @IBOutlet weak var confirmNewPinErrorLabel: UILabel!
    @IBOutlet weak var showHideConfirmNewPinBtn: UIButton!
    @IBOutlet weak var confirmNewPinPinBottomView: UIView!
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    var updateViewElement: UpdateViewElement?
    var isNewUser = false
    
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
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension ResetPinViewController {
    
    func setupView() {
        self.oldPinTextField.delegate = self
        self.newPinTextField.delegate = self
        self.confirmNewPinTextField.delegate = self
        
        self.oldPinTextField.addTarget(self, action: #selector(ResetPinViewController.textFieldDidChange(textField:)), for: .editingChanged)
        self.newPinTextField.addTarget(self, action: #selector(ResetPinViewController.textFieldDidChange(textField:)), for: .editingChanged)
        self.confirmNewPinTextField.addTarget(self, action: #selector(ResetPinViewController.textFieldDidChange(textField:)), for: .editingChanged)
        
        if isNewUser {
            self.showHideOldPinView(action: .hide)
        }else {
            self.showHideOldPinView(action: .show)
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

extension ResetPinViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeView(false)
    }

    @IBAction func showHideOldPinAction(_ sender: UIButton) {
        
        self.oldPinTextField.isSecureTextEntry = !self.oldPinTextField.isSecureTextEntry
        if self.oldPinTextField.isSecureTextEntry {
            self.showHideOldPinBtn.setImage(.eye_slash, for: .normal)
        }else {
            self.showHideOldPinBtn.setImage(.eye, for: .normal)
        }
    }
    
    @IBAction func showHideNewPinAction(_ sender: UIButton) {
        
        self.newPinTextField.isSecureTextEntry = !self.newPinTextField.isSecureTextEntry
        if self.newPinTextField.isSecureTextEntry {
            self.showHideNewPinBtn.setImage(.eye_slash, for: .normal)
        }else {
            self.showHideNewPinBtn.setImage(.eye, for: .normal)
        }
    }
    
    @IBAction func showHideConfirmNewPinAction(_ sender: UIButton) {
        
        self.confirmNewPinTextField.isSecureTextEntry = !self.confirmNewPinTextField.isSecureTextEntry
        if self.confirmNewPinTextField.isSecureTextEntry {
            self.showHideConfirmNewPinBtn.setImage(.eye_slash, for: .normal)
        }else {
            self.showHideConfirmNewPinBtn.setImage(.eye, for: .normal)
        }
    }

    @IBAction func submitAction(_ sender: UIButton) {
        
        if isNewUser {
            if self.newPinTextField.text!.isEmpty {
                self.showHideNewPinError()
                
            }else if self.newPinTextField.text!.isEmpty {
                self.showHideOldPinError(action: .hide)
                self.showHideNewPinError(action: .hide)
                
            }else if self.confirmNewPinTextField.text!.isEmpty {
                self.showHideNewPinError(action: .hide)
                self.showHideConfirmNewPinError()
                
            }else {
                self.showHideNewPinError(action: .hide)
                self.showHideConfirmNewPinError(action: .hide)
                
                guard self.newPinTextField.text! == self.confirmNewPinTextField.text! else { return }
                
                self.requestProxy.requestService()?.setUserPin(newPin: newPinTextField.text!) { (status, response) in
                    guard status else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.closeView(status, date: "Your pincode set successfully")
                    }
                }
            }
            
        }else {
            if self.oldPinTextField.text!.isEmpty {
                self.showHideOldPinError()
                
            }else if self.oldPinTextField.text!.count < 4 {
                self.showHideOldPinError(errorMessage: "Please Enter 4 PIN")
                
            }else if self.newPinTextField.text!.isEmpty {
                self.showHideOldPinError(action: .hide)
                self.showHideNewPinError()
                
            }else if self.newPinTextField.text!.isEmpty {
                self.showHideOldPinError(action: .hide)
                self.showHideNewPinError(action: .hide)
                
            }else if self.confirmNewPinTextField.text!.isEmpty {
                self.showHideOldPinError(action: .hide)
                self.showHideNewPinError(action: .hide)
                self.showHideConfirmNewPinError()
                
            }else {
                self.showHideOldPinError(action: .hide)
                self.showHideNewPinError(action: .hide)
                self.showHideConfirmNewPinError(action: .hide)
                
                guard self.newPinTextField.text! == self.confirmNewPinTextField.text! else {
                    self.showErrorMessage("new pin & confirm pin should be equals")
                    return
                }
                guard self.oldPinTextField.text! != self.newPinTextField.text! else {
                    self.showErrorMessage("Old pin code and new pin code cannot be same")
                    return
                }
                
                self.requestProxy.requestService()?.changePIN(oldPIN: self.oldPinTextField.text!, newPin: newPinTextField.text!) { (status, response) in
                    guard status else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.closeView(status, date: "Your pincode changed successfully")
                    }
                }
            }
        }
    }
    
    @IBAction func forgetPinAction(_ sender: UIButton) {
        
        showConfirmation(message: "Do you want to reset PIN") {
            self.requestProxy.requestService()?.forgetPinCode { (status, response) in
                guard status else { return }
                self.showSuccessMessage(response?.message ?? "")
            }
        }
    }
}

// MARK: - REQUEST DELEGATE

extension ResetPinViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .setUserPin ||
            request == .changePIN ||
            request == .forgetPinCode {
            
            self.showLoadingView(self)
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

extension ResetPinViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count <= 4
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        guard let text = textField.text,
              text.isNotEmpty else {
            return
        }
        
        if textField == self.oldPinTextField && text.count == 4 {
            self.newPinTextField.becomeFirstResponder()
            
        }else if textField == self.newPinTextField && text.count == 4 {
            self.confirmNewPinTextField.becomeFirstResponder()
            
        }else if textField == self.confirmNewPinTextField && text.count == 4 {
            self.view.endEditing(true)
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ResetPinViewController {
    
    private func closeView(_ status: Bool, date: Any? = nil) {
        self.dismiss(animated: true) {
            self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: date)
        }
    }
    
    private func showHideOldPinView(action: ViewErrorsAction) {
        
        switch action {
        case .hide:
            if !self.oldPinContainerView.isHidden {
                self.oldPinContainerView.isHidden = true
                self.containerHeight.constant -= self.oldPinContainerView.frame.height
            }
        case .show:
            if self.oldPinContainerView.isHidden {
                self.oldPinContainerView.isHidden = false
                self.containerHeight.constant += self.oldPinContainerView.frame.height
            }
        }
    }

    private func showHideOldPinError(errorMessage: String = "", action: ViewErrorsAction = .show) {
        
        if errorMessage.isNotEmpty {
            self.oldPinErrorLabel.text = errorMessage
        }else {
            self.oldPinErrorLabel.text = "Please Enter Old PIN"
        }
        
        switch action {
        case .hide:
            if !self.oldPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.oldPinErrorLabel.isHidden = true
                    self.oldPinBottomView.backgroundColor = UIColor.init(named: "light_gray")
                }
            }
        case .show:
            if self.oldPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.oldPinErrorLabel.isHidden = false
                    self.oldPinBottomView.backgroundColor = .systemRed
                }
            }
        }
    }

    private func showHideNewPinError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.newPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.newPinErrorLabel.isHidden = true
                    self.newPinBottomView.backgroundColor = UIColor.init(named: "light_gray")
                }
            }
        case .show:
            if self.newPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.newPinErrorLabel.isHidden = false
                    self.newPinBottomView.backgroundColor = .systemRed
                }
            }
        }
    }

    private func showHideConfirmNewPinError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.confirmNewPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.confirmNewPinErrorLabel.isHidden = true
                    self.confirmNewPinPinBottomView.backgroundColor = UIColor.init(named: "light_gray")
                }
            }
        case .show:
            if self.confirmNewPinErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.confirmNewPinErrorLabel.isHidden = false
                    self.confirmNewPinPinBottomView.backgroundColor = .systemRed
                }
            }
        }
    }
}
