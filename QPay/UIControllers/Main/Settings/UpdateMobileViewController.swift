//
//  UpdateMobileViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class UpdateMobileViewController: ViewController {
    
    @IBOutlet weak var mobileTextField: UITextField!
    
    var updateViewElementDelegate: UpdateViewElement?

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

extension UpdateMobileViewController {
    
    func setupView() {
        self.mobileTextField.delegate = self
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

extension UpdateMobileViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func updateAction(_ sender: UIButton) {
        
        if let mobile = self.mobileTextField.text, mobile.isNotEmpty {
            self.requestProxy.requestService()?.updatePhoneNumber(phone: mobile) { (status, response) in
                if status {
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        self.closeView(status, data: response?.message ?? "")
                    }
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension UpdateMobileViewController: RequestsDelegate {
    func requestStarted(request: RequestType) {
        if request == .updatePhoneNumber {
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

extension UpdateMobileViewController: UITextFieldDelegate {
    
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
        
        if textField == self.mobileTextField {
            if let mobile = mobileTextField.text, mobile.isNotEmpty {
                if mobile.count == 8 {
                }
            }
        }
    }
}

// MARK: CUSTOM FUNCTION

extension UpdateMobileViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}
