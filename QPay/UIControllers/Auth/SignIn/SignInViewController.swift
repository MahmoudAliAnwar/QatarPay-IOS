//
//  LoginViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/1/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import FirebaseMessaging
import DropDown

class SignInViewController: AuthController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var emailStatusImageView: UIImageView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var showHidePasswordBtn: UIButton!
    
    var emailTimer: Timer?
    
    var isCompleteEmail = false {
        willSet {
            self.showHideEmailError(action: newValue ? .hide : .show)
        }
    }
    
    private let signInUsers: SignInUsers = isForDeveloping ? .Niji : .None
    
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
        
        self.changeStatusBarBG(color: .clear)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension SignInViewController {
    
    func setupView() {
        
        self.changeStatusBarBG(color: .clear)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.emailTextField.addTarget(self,
                                      action: #selector(self.textFieldDidChange(_:)),
                                      for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        switch self.signInUsers {
        case .Me:
            self.emailTextField.text = "mode_98@hotmail.com"
            self.passwordTextField.text = "Hamad@2013"
        case .Saneeb:
            self.emailTextField.text = "saneeb@qmobileme.com"
            self.passwordTextField.text = "San@1234"
        case .Niji:
            self.emailTextField.text = "bdo@qmobileme.com"
            self.passwordTextField.text = "User@1234"
        case .Mahmoud:
            self.emailTextField.text = "mahmood.dagga+2@gmail.com"
            self.passwordTextField.text = "User@123"
        case .Test:
            self.emailTextField.text = "test1@user.com"
            self.passwordTextField.text = "Test@123"
        case .Apple:
            self.emailTextField.text = "apple@osoolmedia.com"
            self.passwordTextField.text = "User@123"
        case .None:
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        }
    }
}

// MARK: - ACTIONS

extension SignInViewController {
    
    @IBAction func showHidePasswordAction(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
        if self.passwordTextField.isSecureTextEntry {
            self.showHidePasswordBtn.setImage(.eye_slash, for: .normal)
        } else {
            self.showHidePasswordBtn.setImage(.eye, for: .normal)
        }
    }
    
    @IBAction func signinAction(_ sender: UIButton) {
        
        if self.emailTextField.text!.isEmpty && self.passwordTextField.text!.isEmpty {
            self.showErrorMessage("Username or Password field should not be blank")
            
        } else if self.emailTextField.text!.isEmpty {
            self.showErrorMessage("Username should not be blank")
            
        } else if self.passwordTextField.text!.isEmpty {
            self.showErrorMessage("Password should not be blank")
            
        } else {
            if isCompleteEmail {
                guard let email = self.emailTextField.text, email.isNotEmpty,
                      let password = self.passwordTextField.text, password.isNotEmpty else {
                    return
                }
                self.requestProxy.requestService()?.signIn(email, password, ( weakify { strong, user in
                }))
            }
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(ForgotPasswordViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signupAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(SignUpViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension SignInViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        
        self.emailTimer?.invalidate()
        self.emailTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
            
            guard let email = textField.text, email.isNotEmpty else {
                self.isCompleteEmail = false
                return
            }
            
            if !isValidEmail(email) {
                self.isCompleteEmail = false
                
            }else {
                self.requestProxy.requestService()?.checkEmailRegisterd(email, (self.weakify { strong, status in
                    strong.isCompleteEmail = status
                }))
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
            
        }else if textField == self.passwordTextField {
            self.view.endEditing(true)
        }
        
        return true
    }
}

// MARK: - REQUESTS DELEGATE

extension SignInViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .signIn {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        switch result {
        case .Success(let data):
            guard let user = data as? User else { return }
            guard user.isDigitalSignature == "True" else {
                let vc = self.getStoryboardView(SignatureViewController.self)
                vc.email = self.emailTextField.text!
                vc.password = self.passwordTextField.text!
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            DispatchQueue.global(qos: .background).async {
                Messaging.messaging().token { token, error in
                    guard error == nil,
                          let token = token else {
                        return
                    }
                    self.requestProxy.requestService()?.sendDeviceToken(token, ( self.weakify { strong, object in
                    }))
                }
            }
            self.showHomeView()
            
            break
        case .Failure(let errorType):
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.showErrorMessage("The user name or password is incorrect")
                switch errorType {
                case .Exception(_):
                    break
                case .AlamofireError(_):
                    break
                case .Runtime(_):
                    break
                }
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension SignInViewController {
    
    private func showHideEmailError(action: ViewErrorsAction = .show) {
        switch action {
        case .hide:
            if !self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.emailErrorLabel.isHidden = true
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
//                    self.containerViewHeight.constant -= self.emailErrorLabel.frame.height
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
            
        case .show:
            if self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
//                    self.containerViewHeight.constant += self.emailErrorLabel.frame.height
                    self.emailErrorLabel.isHidden = false
                    self.emailStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
        }
    }
}

extension MainController {
    
    public func logoutView() {
        self.userProfile.logout()
        let vc = self.getStoryboardView(MySplashViewController.self)
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
