//
//  AddPinViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class AddPinViewController: MainController {
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        localized()
        setupData()
        fetchData()
    }
}

extension AddPinViewController {
    
    func setupView() {
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddPinViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func showHideNewPinAction(_ sender: UIButton) {
        
        self.newPinTextField.isSecureTextEntry = !self.newPinTextField.isSecureTextEntry
        if self.newPinTextField.isSecureTextEntry {
            self.showHideNewPinBtn.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        }else {
            self.showHideNewPinBtn.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func showHideConfirmNewPinAction(_ sender: UIButton) {
        
        self.confirmNewPinTextField.isSecureTextEntry = !self.confirmNewPinTextField.isSecureTextEntry
        if self.confirmNewPinTextField.isSecureTextEntry {
            self.showHideConfirmNewPinBtn.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        }else {
            self.showHideConfirmNewPinBtn.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
    }

    @IBAction func saveAction(_ sender: UIButton) {
        
        if self.newPinTextField.text!.isEmpty {
            self.showHideNewPinError()
            
        }else if self.newPinTextField.text!.isEmpty {
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
                self.showSuccessMessage("Your pincode set successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    self.closeView(status)
                }
            }
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension AddPinViewController: UITextFieldDelegate {
    
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
        
        if let text = textField.text, text.isNotEmpty {
            
            if textField == self.newPinTextField && text.count == 4 {
                self.confirmNewPinTextField.becomeFirstResponder()
                
            }else if textField == self.confirmNewPinTextField && text.count == 4 {
                self.view.endEditing(true)
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension AddPinViewController {
    
    private func closeView(_ status: Bool) {
        
        self.updateViewElement?.elementUpdated(fromSourceView: self, status: status, data: nil)
        self.dismiss(animated: true)
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
