//
//  ConfirmPhoneNumberViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/16/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmPhoneNumberViewController: ViewController {
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var code5TextField: UITextField!
    @IBOutlet weak var code6TextField: UITextField!
    
    var updateViewElement: UpdateViewElement?
    
    var isCompleteCode1 = false
    var isCompleteCode2 = false
    var isCompleteCode3 = false
    var isCompleteCode4 = false
    var isCompleteCode5 = false
    var isCompleteCode6 = false

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

extension ConfirmPhoneNumberViewController {
    
    func setupView() {
        self.code1TextField.addTarget(self, action: #selector(self.textFieldDidBegin(textField:)), for: .editingDidBegin)
        self.code2TextField.addTarget(self, action:  #selector(self.textFieldDidBegin), for: .editingDidBegin)
        self.code3TextField.addTarget(self, action:  #selector(self.textFieldDidBegin), for: .editingDidBegin)
        self.code4TextField.addTarget(self, action:  #selector(self.textFieldDidBegin), for: .editingDidBegin)
        self.code5TextField.addTarget(self, action:  #selector(self.textFieldDidBegin), for: .editingDidBegin)
        self.code6TextField.addTarget(self, action:  #selector(self.textFieldDidBegin), for: .editingDidBegin)
        
        self.code1TextField.addTarget(self, action: #selector(self.textField1DidChange(textField:)), for: .editingChanged)
        self.code2TextField.addTarget(self, action:  #selector(self.textField2DidChange(textField:)), for: .editingChanged)
        self.code3TextField.addTarget(self, action:  #selector(self.textField3DidChange(textField:)), for: .editingChanged)
        self.code4TextField.addTarget(self, action:  #selector(self.textField4DidChange(textField:)), for: .editingChanged)
        self.code5TextField.addTarget(self, action:  #selector(self.textField5DidChange(textField:)), for: .editingChanged)
        self.code6TextField.addTarget(self, action:  #selector(self.textField6DidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension ConfirmPhoneNumberViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        guard isCompleteCode1,
              isCompleteCode2,
              isCompleteCode3,
              isCompleteCode4,
              isCompleteCode5,
              isCompleteCode6 else {
            return
        }
        
        guard let code1 = self.code1TextField.text, code1.isNotEmpty,
              let code2 = self.code2TextField.text, code2.isNotEmpty,
              let code3 = self.code3TextField.text, code3.isNotEmpty,
              let code4 = self.code4TextField.text, code4.isNotEmpty,
              let code5 = self.code5TextField.text, code5.isNotEmpty,
              let code6 = self.code6TextField.text, code6.isNotEmpty else {
            return
        }
        
        let userCode = "\(code1)\(code2)\(code3)\(code4)\(code5)\(code6)"
        
        guard let profile = self.userProfile.getProfile(),
              let mobile = profile.mobile else {
            return
        }
        
        self.requestProxy.requestService()?.confirmPhoneNumber(mobile, code: userCode, ( weakify { strong, object in
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard let presentingView = self.presentingViewController?.children.last as? ViewController else { return }
                self.closeView(true)
                
                presentingView.showSuccessMessage(object?.message ?? "Phone confirmed successfully")
            }
        }))
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmPhoneNumberViewController: RequestsDelegate {

    func requestStarted(request: RequestType) {
        if request == .confirmPhoneNumber {
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

extension ConfirmPhoneNumberViewController: UITextFieldDelegate {
    
    @objc func textFieldDidBegin(textField: UITextField) {
        textField.text?.removeAll()
    }
    
    @objc func textField1DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.code2TextField.becomeFirstResponder()
                self.isCompleteCode1 = true
            }else {
                self.isCompleteCode1 = true
            }
        }
    }
    
    @objc func textField2DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.code3TextField.becomeFirstResponder()
                self.isCompleteCode2 = true
            }else {
                self.isCompleteCode2 = true
            }
        }
    }
    
    @objc func textField3DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.code4TextField.becomeFirstResponder()
                self.isCompleteCode3 = true
            }else {
                self.isCompleteCode3 = true
            }
        }
    }
    
    @objc func textField4DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.code5TextField.becomeFirstResponder()
                self.isCompleteCode4 = true
            }else {
                self.isCompleteCode4 = true
            }
        }
    }
    
    @objc func textField5DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.code6TextField.becomeFirstResponder()
                self.isCompleteCode5 = true
            }else {
                self.isCompleteCode5 = true
            }
        }
    }
    
    @objc func textField6DidChange(textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 1 {
                self.view.endEditing(true)
                self.isCompleteCode6 = true
            }else {
                self.isCompleteCode6 = true
            }
        }
    }
    
}

// MARK: - CUSTOM FUNCTIONS

extension ConfirmPhoneNumberViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: nil)
    }
}
