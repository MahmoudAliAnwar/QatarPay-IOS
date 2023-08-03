//
//  QIDViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import QKMRZScanner
import BarcodeScanner

class QIDViewController: AuthController {
    
    @IBOutlet weak var qidTextField: UITextField!
    @IBOutlet weak var qidErrorLabel: UILabel!
    @IBOutlet weak var qidStatusImageView: UIImageView!
    
    @IBOutlet weak var passportNumberTextField: UITextField!
    @IBOutlet weak var passportErrorLabel: UILabel!
    @IBOutlet weak var passportStatusImageView: UIImageView!
    
    @IBOutlet weak var submitVerifyButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var isCompleteQID = false {
        willSet {
            self.showHideQIDError(action: newValue ? .hide : .show)
        }
    }
    
    var isCompletePassport = false {
        willSet {
            self.showHidePassportError(action: newValue ? .hide : .show)
        }
    }
    
    var parentView: UIViewController?
    
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

extension QIDViewController {
    
    func setupView() {
        self.changeStatusBarBG(color: .clear)
    
        self.qidTextField.isEnabled = false
        self.passportNumberTextField.isEnabled = false
        
        self.skipButton.isHidden = self.navigationController?.getPreviousView() is PersonalInfoViewController
        
//        self.qidTextField.delegate = self
//        self.passportNumberTextField.delegate = self

//        self.qidTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
//        self.passportNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension QIDViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadQIDAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(UploadQIDViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func uploadPassportAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(PassportViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.showHome()
    }
    
    @IBAction func skipAction(_ sender: UIButton) {
        self.showHome()
    }
}

// MARK: - TEXT FIELD DELEGATE

extension QIDViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.qidTextField {
            return count <= 11
        }
        return true
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == self.qidTextField {
            guard let qid = qidTextField.text, qid.isNotEmpty else {
                self.isCompleteQID = false
                return
            }
            self.qidErrorLabel.text = "Enter valid Qatar id"
            
            guard qid.count == 11 else {
                self.isCompleteQID = false
                return
            }
            self.requestProxy.requestService()?.checkQID(qidNumber: qid) { (status) in
                if status {
                    self.qidErrorLabel.text = "QID number already existing in Qatar Pay"
                }
                self.isCompleteQID = !status
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension QIDViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .generatePhoneToken ||
            request == .confirmPhoneNumber {
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

extension QIDViewController {
    
    public func setQIDNumberToField(_ number: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            self.qidTextField.text = number
//            self.textFieldDidChange(textField: self.qidTextField)
        }
    }
    
    public func setPassportNumberToField(_ number: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            self.passportNumberTextField.text = number
//            self.textFieldDidChange(textField: self.passportNumberTextField)
        }
    }
    
    private func showHome() {
        self.showSuccessMessage("User created successfuly. Please check your email and verify your account to complete your registration.")
        self.userProfile.removeSignUpData()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.showHomeView()
        }
    }
    
    private func showHideQIDError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.qidErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qidErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.qidErrorLabel.frame.height
                }
            }
            self.qidStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
            
        case .show:
            if self.qidErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qidErrorLabel.isHidden = false
                    self.containerViewHeight.constant += self.qidErrorLabel.frame.height
                }
            }
            self.qidStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
        }
    }
    
    private func showHidePassportError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.passportErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.passportErrorLabel.isHidden = true
                    self.containerViewHeight.constant -= self.passportErrorLabel.frame.height
                }
            }
            self.passportStatusImageView.image = #imageLiteral(resourceName: "ic_succes")
            
        case .show:
            if self.passportErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.passportErrorLabel.isHidden = false
                    self.containerViewHeight.constant += self.passportErrorLabel.frame.height
                }
            }
            self.passportStatusImageView.image = #imageLiteral(resourceName: "ic_wrong")
        }
    }
}
