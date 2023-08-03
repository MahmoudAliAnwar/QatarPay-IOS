//
//  SignUpViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class SignUpViewController: AuthController {
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    @IBOutlet weak var fullNameStatusImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailStatusImageView: UIImageView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    @IBOutlet weak var passwordStrengthView: UIView!
    @IBOutlet weak var passwordStrengthProgress1: UIProgressView!
    @IBOutlet weak var passwordStrengthProgress2: UIProgressView!
    @IBOutlet weak var passwordStrengthProgress3: UIProgressView!
    @IBOutlet weak var passwordStrengthProgress4: UIProgressView!
    @IBOutlet weak var passwordStrengthProgress5: UIProgressView!
    
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    @IBOutlet weak var showHideConfirmPasswordBtn: UIButton!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var isCompleteFullName = false {
        didSet {
            if isCompleteFullName {
                self.showHideFullNameError(action: .hide)
            }else {
                self.showHideFullNameError()
            }
        }
    }
    var isCompleteEmail = false {
        didSet {
            if isCompleteEmail {
                self.showHideEmailError(action: .hide)
            }else {
                self.showHideEmailError()
            }
        }
    }
    var isCompletePassword = false {
        didSet {
            if isCompletePassword {
                self.showHidePasswordError(action: .hide)
            }else {
                self.showHidePasswordError()
            }
        }
    }
    var isCompleteConfirmPassword = false {
        didSet {
            if isCompleteConfirmPassword {
                self.showHideConfirmPasswordError(action: .hide)
            }else {
                self.showHideConfirmPasswordError()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        localized()
        setupData()
        fetchData()
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension SignUpViewController {
    
    func setupView() {
        self.changeStatusBarBG(color: .clear)
        
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        fullNameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange(textField:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange(textField:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension SignUpViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        if self.fullNameTextField.text!.isEmpty {
            self.isCompleteFullName = false
            
        }else if self.emailTextField.text!.isEmpty {
            self.isCompleteEmail = false
            
        }else if self.passwordTextField.text!.isEmpty {
            self.isCompletePassword = false
            
        }else if self.confirmPasswordTextField.text!.isEmpty {
            self.isCompleteConfirmPassword = false
            
        }else {
            if isCompleteFullName && isCompleteEmail && isCompletePassword && isCompleteConfirmPassword {
                
                let fullName = self.fullNameTextField.text!
                let email = self.emailTextField.text!
                let password = self.passwordTextField.text!
                let confirm = self.confirmPasswordTextField.text!
                
                let fullNameArr = fullName.components(separatedBy: .whitespaces)
                var lastName = ""
                for i in 1..<fullNameArr.count {
                    if i == 1 {
                        lastName += fullNameArr[i]
                    }else {
                        lastName += " \(fullNameArr[i])"
                    }
                }
                
                let signUpData : SignUpData = (firstName: fullNameArr[0], lastName: lastName, email: email, password: password, confirmPassword: confirm)
                
                self.userProfile.saveSignUpData(data: signUpData)
                
                self.requestProxy.requestService()?.signUp(signUpData: userProfile.getSignUpData(), accountType: .qatarPay) { (status, baseReponse) in
                    guard status == true else { return }
                    self.showSuccessMessage("Sign up successfully")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        let vc = self.getStoryboardView(SignatureViewController.self)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func showHidePasswordAction(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        if self.passwordTextField.isSecureTextEntry {
            self.showHidePasswordBtn.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        }else {
            self.showHidePasswordBtn.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func showHideConfirmAction(_ sender: UIButton) {
        self.confirmPasswordTextField.isSecureTextEntry = !self.confirmPasswordTextField.isSecureTextEntry
        if self.confirmPasswordTextField.isSecureTextEntry {
            self.showHideConfirmPasswordBtn.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        }else {
            self.showHideConfirmPasswordBtn.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
    }
}

// MARK: - REQUEST DELEGATE

extension SignUpViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        showLoadingView(self)
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
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

// MARK: - TEXT FIELD DELEGATE

extension SignUpViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == fullNameTextField {
            if let fullName = fullNameTextField.text, fullName.isNotEmpty {
                
                let array = fullName.components(separatedBy: .whitespaces)
                if array.count > 1, array[1].isNotEmpty {
                    self.isCompleteFullName = true
                }else {
                    self.isCompleteFullName = false
                }
            }
            
        }else if textField == emailTextField {
            
            if let email = emailTextField.text, email.isNotEmpty {
                if !isValidEmail(email) {
                    self.isCompleteEmail = false
                    
                }else {
                    self.requestProxy.requestService()?.checkEmailRegisterd(email) { (status) in
                        self.isCompleteEmail = !status
                    }
                }
            }else {
                self.isCompleteEmail = false
            }
            
        }else if textField == passwordTextField {
            if let password = passwordTextField.text, password.isNotEmpty {
                
                let strength = checkPasswordStrength(password: password)
                self.isCompletePassword = strength >= 5
                self.setProgressViewFull(number: strength)
                
            }else {
                self.setProgressViewFull(number: 0)
                self.isCompletePassword = false
            }
            
        }else if textField == confirmPasswordTextField {
            if let confirmPassword = confirmPasswordTextField.text, confirmPassword.isNotEmpty {
                if let password = passwordTextField.text, password.isNotEmpty {
                    
                    self.isCompleteConfirmPassword = confirmPassword == password
                }
            }else {
                self.isCompleteConfirmPassword = false
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == fullNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        }else if textField == confirmPasswordTextField {
            view.endEditing(true)
        }
        return true
    }
}

// MARK: - PRIVATE FUNCTIONS

extension SignUpViewController {
    
    private func setProgressViewFull(number: Int) {
        
        let array: [UIProgressView] = [
            self.passwordStrengthProgress1,
            self.passwordStrengthProgress2,
            self.passwordStrengthProgress3,
            self.passwordStrengthProgress4,
            self.passwordStrengthProgress5
        ]

        if number >= 0 && number <= 5 {

            for (index, progress) in array.enumerated() {
                if number == 0 {
                    progress.setProgress(0, animated: true)
                    
                }else if number > 0 {
                    if index < number {
                        progress.setProgress(1, animated: true)
                    }else {
                        progress.setProgress(0, animated: true)
                    }
                }
            }
            
            if number <= 2 {
                self.setProgressViewColor(color: .systemRed)
            }else if number < 5 {
                self.setProgressViewColor(color: .systemYellow)
            }else{
                self.setProgressViewColor(color: .systemGreen)
            }
        }
    }
    
    private func setProgressViewColor(color: UIColor) {

        self.passwordStrengthProgress1.progressTintColor = color
        self.passwordStrengthProgress2.progressTintColor = color
        self.passwordStrengthProgress3.progressTintColor = color
        self.passwordStrengthProgress4.progressTintColor = color
        self.passwordStrengthProgress5.progressTintColor = color
    }
    
    private func showHideFullNameError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.fullNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.fullNameErrorLabel.isHidden = true
                    self.fullNameStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
                    self.containerViewHeight.constant -= self.fullNameErrorLabel.frame.height
//                    self.isCompleteFullName = self.fullNameErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.fullNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.fullNameErrorLabel.frame.height
                    self.fullNameErrorLabel.isHidden = false
                    self.fullNameStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
//                    self.isCompleteFullName = self.fullNameErrorLabel.isHidden
                }
            }
        }
    }
    
    private func showHideEmailError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.emailErrorLabel.isHidden = true
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
                    self.containerViewHeight.constant -= self.emailErrorLabel.frame.height
//                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.emailErrorLabel.frame.height
                    self.emailErrorLabel.isHidden = false
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
//                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
        }
    }
    
    private func showHidePasswordError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.passwordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.passwordErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.passwordErrorLabel.frame.height
//                    self.isCompletePassword = self.passwordErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.passwordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.passwordErrorLabel.frame.height
                    self.passwordErrorLabel.isHidden = false
//                    self.isCompletePassword = self.passwordErrorLabel.isHidden
                }
            }
        }
    }
    
    private func showHideConfirmPasswordError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.confirmPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.confirmPasswordErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.confirmPasswordErrorLabel.frame.height
//                    self.isCompleteConfirmPassword = self.confirmPasswordErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.confirmPasswordErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.containerViewHeight.constant += self.confirmPasswordErrorLabel.frame.height
                    self.confirmPasswordErrorLabel.isHidden = false
//                    self.isCompleteConfirmPassword = self.confirmPasswordErrorLabel.isHidden
                }
            }
        }
    }
    
}

/*

             let validationId = PasswordStrengthManager.checkValidationWithUniqueCharacter(pass: password, rules: PasswordRules.passwordRule, minLength: PasswordRules.minPasswordLength, maxLength: PasswordRules.maxPasswordLength)
             
             print(validationId)
             UIView.animate(withDuration: 0.5, delay: 0, options: [],  animations: { [weak self] in
                 
 //                print("Strength \(validationId.strength)")
                 let progressInfo = PasswordStrengthManager.setProgressView(strength: validationId.strength)
 //                print("Info \(progressInfo.percentage)")
                 
                 if self!.passwordStrengthView.isHidden {
                     self?.passwordStrengthView.isHidden = false
                     self?.containerViewHeight.constant += self?.passwordStrengthView.frame.height ?? 0
                 }
                 
                 switch validationId.strength {
                     
                 case .weak:
                     self?.setProgressViewFull(number: 1)
                     
                 case .medium:
                     self?.setProgressViewFull(number: 2)
                     
                 case .strong:
                     self?.setProgressViewFull(number: 3)
                     
                 case .veryStrong:
                     self?.setProgressViewFull(number: 5)
                 }
                 
 //                self.isPasswordValid = progressInfo.shouldValid
 //                self.strengthProgressView.setProgress(progressInfo.percentage, animated: true)
 //                self.strengthProgressView.progressTintColor = UIColor.colorFrom(hexString: progressInfo.color)
             })
             
         }else {
             UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { [weak self] in

                 self?.setProgressViewFull(number: 0)
 //                print("Password cannot be empty.")
                 
         }) { (_) in
                 UIView.animate(withDuration: 0.8, delay: 0, options: [], animations: { [weak self] in
                     
                 })
            }
 */
