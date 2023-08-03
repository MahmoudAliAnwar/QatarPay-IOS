//
//  QIDMobileViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/06/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class QIDMobileViewController: AuthController {
    
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var mobileStatusImageView: UIImageView!
    
    @IBOutlet weak var firstCodeTextField: UITextField!
    @IBOutlet weak var secondCodeTextField: UITextField!
    @IBOutlet weak var thirdCodeTextField: UITextField!
    @IBOutlet weak var fourthCodeTextField: UITextField!
    @IBOutlet weak var fiveCodeTextField: UITextField!
    @IBOutlet weak var sixCodeTextField: UITextField!
    
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    @IBOutlet weak var submitVerifyButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var mobileVerificationView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var isCompleteMobile = false {
        willSet {
            self.showHideMobileError(action: newValue ? .hide : .show)
        }
    }
    
    var phoneNumber: String?
    var phoneCode: String?
    
    var isCompleteFirstCode = false
    var isCompleteSecondCode = false
    var isCompleteThirdCode = false
    var isCompleteFourthCode = false
    var isCompleteFiveCode = false
    var isCompleteSixCode = false
    
    var isShowVerificationView = false
    
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

extension QIDMobileViewController {
    
    func setupView() {
        self.changeStatusBarBG(color: .clear)
        
        self.mobileTextField.delegate = self
        
        self.skipButton.isHidden = self.navigationController?.getPreviousView() is PersonalInfoViewController
        
        self.mobileTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        self.firstCodeTextField.addTarget(self, action: #selector(self.textField1DidChange(textField:)), for: .editingChanged)
        self.secondCodeTextField.addTarget(self, action: #selector(self.textField2DidChange(textField:)), for: .editingChanged)
        self.thirdCodeTextField.addTarget(self, action: #selector(self.textField3DidChange(textField:)), for: .editingChanged)
        self.fourthCodeTextField.addTarget(self, action: #selector(self.textField4DidChange(textField:)), for: .editingChanged)
        self.fiveCodeTextField.addTarget(self, action: #selector(self.textField5DidChange(textField:)), for: .editingChanged)
        self.sixCodeTextField.addTarget(self, action: #selector(self.textField6DidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension QIDMobileViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCodeAction(_ sender: UIButton) {
        guard let mobile = phoneNumber else { return }
        self.sendGeneratePhoneTokenRequest(mobile)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if !self.isShowVerificationView {
            
            guard let mobile = self.mobileTextField.text,
                  mobile.isNotEmpty else {
                self.showHideMobileError()
                return
            }
            
            guard isCompleteMobile == true else { return }
            self.showHideMobileError(action: .hide)
            
            showConfirmation(message: "Verify your phone number \(mobile)") {
                
                /// Update phone number request...
                self.requestProxy.requestService()?.updatePhoneNumberFromRegister(phoneNumber: mobile, ( self.weakify { strong, object in
                }))
                
                /// Generate phone token request...
                self.sendGeneratePhoneTokenRequest(mobile) {
                    self.phoneNumber = mobile
                    self.showHideVerificationView()
                    self.submitVerifyButton.setTitle("Verify", for: .normal)
                }
            }
            
        }else {
            guard isCompleteFirstCode,
                  isCompleteSecondCode,
                  isCompleteThirdCode,
                  isCompleteFourthCode,
                  isCompleteFiveCode,
                  isCompleteSixCode else {
                return
            }
            
            guard let mobile = phoneNumber else { return }
            
            var code = ""
            code += self.firstCodeTextField.text!
            code += self.secondCodeTextField.text!
            code += self.thirdCodeTextField.text!
            code += self.fourthCodeTextField.text!
            code += self.fiveCodeTextField.text!
            code += self.sixCodeTextField.text!
            self.phoneCode = code
            
            self.requestProxy.requestService()?.confirmPhoneNumber(mobile, code: code, ( weakify { strong, object in
                guard let parentVC = strong.navigationController?.getPreviousView() else {
                    return
                }
                
                if parentVC is PersonalInfoViewController {
                    strong.navigationController?.popViewController(animated: true)
                } else {
                    strong.showQIDView()
                }
            }))
        }
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        self.showQIDView()
    }
}

// MARK: - TEXT FIELD DELEGATE

extension QIDMobileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.mobileTextField {
            return count <= 8
        }
        return true
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == self.mobileTextField {
            guard let mobile = mobileTextField.text, mobile.isNotEmpty else {
                self.isCompleteMobile = false
                return
            }
//            self.mobileErrorLabel.text = "Enter valid mobile"
            
            self.isCompleteMobile = mobile.count == 8
            
//                self.requestProxy.requestService()?.checkPhoneRegisterd(phoneNumber: mobile) { (status) in
//                    if status {
//                        self.mobileErrorLabel.text = "Phone number already existing in Qatar Pay"
//                    }
//                    self.isCompleteMobile = !status
//                }
        }
    }
    
    @objc func textField1DidChange(textField : UITextField) {
        
        if textField == self.firstCodeTextField {
            guard let first = firstCodeTextField.text, first.isNotEmpty else {
                self.isCompleteFirstCode = false
                return
            }
            
            if first.count == 1 {
                self.secondCodeTextField.becomeFirstResponder()
                self.isCompleteFirstCode = true
            }
        }
    }
    
    @objc func textField2DidChange(textField : UITextField) {
        
        if textField == self.secondCodeTextField {
            guard let second = secondCodeTextField.text, second.isNotEmpty else {
                self.isCompleteSecondCode = false
                return
            }
            
            if second.count == 1 {
                self.thirdCodeTextField.becomeFirstResponder()
                self.isCompleteSecondCode = true
            }
        }
    }
    
    @objc func textField3DidChange(textField : UITextField) {
        
        if textField == self.thirdCodeTextField {
            guard let third = thirdCodeTextField.text, third.isNotEmpty else {
                self.isCompleteThirdCode = false
                return
            }
            
            if third.count == 1 {
                self.fourthCodeTextField.becomeFirstResponder()
                self.isCompleteThirdCode = true
            }
        }
    }
    
    @objc func textField4DidChange(textField : UITextField) {
        
        if textField == self.fourthCodeTextField {
            guard let fourth = fourthCodeTextField.text, fourth.isNotEmpty else {
                self.isCompleteFourthCode = false
                return
            }
            
            if fourth.count == 1 {
                self.fiveCodeTextField.becomeFirstResponder()
                self.isCompleteFourthCode = true
            }
        }
    }
    
    @objc func textField5DidChange(textField : UITextField) {
        
        if textField == self.fiveCodeTextField {
            guard let five = fiveCodeTextField.text, five.isNotEmpty else {
                self.isCompleteFiveCode = false
                return
            }
            
            if five.count == 1 {
                self.sixCodeTextField.becomeFirstResponder()
                self.isCompleteFiveCode = true
            }
        }
    }
    
    @objc func textField6DidChange(textField : UITextField) {
        
        if textField == self.sixCodeTextField {
            guard let six = sixCodeTextField.text, six.isNotEmpty else {
                self.isCompleteSixCode = false
                return
            }
            
            if six.count == 1 {
                self.view.endEditing(true)
                self.isCompleteSixCode = true
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension QIDMobileViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .generatePhoneToken || request == .confirmPhoneNumber {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        self.hideLoadingView()
        
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

// MARK: - PRIVATE FUNCTIONS

extension QIDMobileViewController {
    
    private func showQIDView() {
        let vc = self.getStoryboardView(QIDViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendGeneratePhoneTokenRequest(_ mobile: String, completion: voidCompletion? = nil) {
        self.requestProxy.requestService()?.generatePhoneToken(phone: mobile) { (status, response) in
            guard status == true else { return }
            
            self.showSuccessMessage(response?.message ?? "Code sent successfully")
            completion?()
        }
    }
    
    private func showHideVerificationView(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.mobileVerificationView.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileVerificationView.isHidden = true
                    self.containerViewHeight.constant -= self.mobileVerificationView.frame.height + 10
                    self.isShowVerificationView = false
                }
            }
        case .show:
            if self.mobileVerificationView.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileVerificationView.isHidden = false
                    self.containerViewHeight.constant += self.mobileVerificationView.frame.height + 10
                    self.isShowVerificationView = true
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
                    self.containerViewHeight.constant -= self.mobileErrorLabel.frame.height
                    self.mobileStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
                }
            }
        case .show:
            if self.mobileErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileErrorLabel.isHidden = false
                    self.containerViewHeight.constant += self.mobileErrorLabel.frame.height
                    self.mobileStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
                }
            }
        }
    }
}
