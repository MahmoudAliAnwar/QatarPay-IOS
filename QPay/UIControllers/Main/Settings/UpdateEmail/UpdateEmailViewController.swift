//
//  UpdateEmailViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class UpdateEmailViewController: ViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
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

extension UpdateEmailViewController {
    
    func setupView() {
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension UpdateEmailViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func updateAction(_ sender: UIButton) {
        
        guard let email = self.emailTextField.text, email.isNotEmpty else { return }
        
        self.requestProxy.requestService()?.updateEmail(email: email) { (status, response) in
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.closeView(status, data: response?.message ?? "")
                }
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension UpdateEmailViewController: RequestsDelegate {
    func requestStarted(request: RequestType) {
        if request == .updateEmail {
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

extension UpdateEmailViewController {
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == self.emailTextField {
            if let email = emailTextField.text, email.isNotEmpty {
                if isValidEmail(email) {
                }
            }
        }
    }
}

// MARK: CUSTOM FUNCTION

extension UpdateEmailViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
}
