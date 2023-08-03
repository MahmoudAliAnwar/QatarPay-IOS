//
//  CreditCardAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CreditCardAccountViewController: MainController {

    @IBOutlet weak var accountNameTextField: UITextField!
    
    @IBOutlet weak var code1TextField: UITextField!
    @IBOutlet weak var code2TextField: UITextField!
    @IBOutlet weak var code3TextField: UITextField!
    @IBOutlet weak var code4TextField: UITextField!
    @IBOutlet weak var codeNumberContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var codeNumberErrorLabel: UILabel!
    
    @IBOutlet weak var dateMonthField: UITextField!
    @IBOutlet weak var dateYearTextField: UITextField!
    @IBOutlet weak var expiryContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var expiryErrorLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cvvErrorLabel: UILabel!
    
    @IBOutlet weak var isDefaultAccountCheckBox: CheckBox!
    
    private var code1Complete = false
    private var code2Complete = false
    private var code3Complete = false
    private var code4Complete = false
    
    private var monthComplete = false
    private var yearComplete = false
    
    private var isDefaultAccount = false
    
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

extension CreditCardAccountViewController {
    
    func setupView() {
        self.isDefaultAccountCheckBox.style = .tick
        self.isDefaultAccountCheckBox.borderStyle = .square
        self.isDefaultAccountCheckBox.borderWidth = 1
        
        self.isDefaultAccountCheckBox.addTarget(self,
                                                action: #selector(onCheckBoxValueChange(_:)),
                                                for: .valueChanged)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CreditCardAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func scanCardAction(_ sender: UIButton) {
        
        guard let vc = CreditCardScannerViewController.createViewController(withDelegate: self) else {
//            print("This device is incompatible with CardScan")
            self.showErrorMessage("This device is incompatible with CardScan")
            return
        }
        self.present(vc, animated: true)
    }

    @IBAction func saveAccountAction(_ sender: UIButton) {
        
        if !self.isCardNumberFull() {
            self.showHideCodeNumberError()
            
        }else if !self.isDateFull() {
            self.showHideCodeNumberError(action: .hide)
            self.showHideExpiryError()
            
        }else if self.nameTextField.text!.isEmpty {
            self.showHideCodeNumberError(action: .hide)
            self.showHideExpiryError(action: .hide)
            self.showHideNameError()
            
        }else if !self.isCvvFull() {
            self.showHideCodeNumberError(action: .hide)
            self.showHideExpiryError(action: .hide)
            self.showHideNameError(action: .hide)
            self.showHideCVVError()
            
        }else {
            self.showHideCodeNumberError(action: .hide)
            self.showHideExpiryError(action: .hide)
            self.showHideNameError(action: .hide)
            self.showHideCVVError(action: .hide)
            
            if let code1 = self.code1TextField.text, code1.isNotEmpty,
               let code2 = self.code2TextField.text, code2.isNotEmpty,
               let code3 = self.code3TextField.text, code3.isNotEmpty,
               let code4 = self.code4TextField.text, code4.isNotEmpty,
               let month = self.dateMonthField.text, month.isNotEmpty,
               let year = self.dateYearTextField.text, year.isNotEmpty,
               let name = self.nameTextField.text, name.isNotEmpty,
               let cvv = self.cvvTextField.text, cvv.isNotEmpty {
                
                var fullCode = ""
                
                if self.isCardDataFull() {
                    fullCode += code1
                    fullCode += code2
                    fullCode += code3
                    fullCode += code4
                    
                    if self.isCvvFull() {
                        
//                        let date = "\(month) \(year)"
//                            let _ = CardObject(name: name, type: .Visa, number: fullCode, owner: name, expiryDate: date, cvv: cvv, paymentCardType: .Credit)
                    }
                }
            }
        }
    }

    @IBAction func setDefaultAccountAction(_ sender: UIButton) {
        self.isDefaultAccountCheckBox.isChecked.toggle()
        self.changeCheckBoxStatus(self.isDefaultAccountCheckBox.isChecked)
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        self.changeCheckBoxStatus(sender.isChecked)
    }
    
    private func changeCheckBoxStatus(_ status: Bool) {
        self.isDefaultAccount = status
    }
}

// MARK: - VISION CONTROLLER DELEGATE

extension CreditCardAccountViewController: CreditCardScannerViewControllerDelegate {
    
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: VisionCreditCard) {
        viewController.dismiss(animated: true)
        
//        self.cardImageView.image = .none
//        if let img = card.image {
//            self.cardImageView.image = img
//        }
        
        let number = card.number ?? ""
        
        if number.isNotEmpty, number.count >= 16 {
            self.code1TextField.text?.removeAll()
            self.code2TextField.text?.removeAll()
            self.code3TextField.text?.removeAll()
            self.code4TextField.text?.removeAll()
            
            let code = trimCode(number)
            self.code1TextField.text = code[0]
            self.code2TextField.text = code[1]
            self.code3TextField.text = code[2]
            self.code4TextField.text = code[3]
            
            self.code1FieldDidChange(self.code1TextField)
            self.code2FieldDidChange(self.code2TextField)
            self.code3FieldDidChange(self.code3TextField)
            self.code4FieldDidChange(self.code4TextField)
        }
        
        if let expiryMonth = card.expireDate?.month,
           expiryMonth.description.count == 2 {
            self.dateMonthField.text?.removeAll()
            
            self.dateMonthField.text = expiryMonth.description
            self.dateMonthFieldDidChange(self.dateMonthField)
        }
        
        if let expiryYear = card.expireDate?.year,
           expiryYear.description.count == 4 {
            self.dateYearTextField.text?.removeAll()
            
            self.dateYearTextField.text = "\(expiryYear.description.suffix(2))"
            self.dateYearFieldDidChange(self.dateYearTextField)
        }
        
        if let name = card.name,
           name.isNotEmpty {
            
            self.nameTextField.text?.removeAll()
            self.nameTextField.text = name
        }
    }
    
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError) {
        
        viewController.dismiss(animated: true)
        print(error.localizedDescription)
    }
}

// MARK: - REQUESTS DELEGATE

extension CreditCardAccountViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .paymentRequests {
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

// MARK: - TEXT FIELDS DELEGATE

extension CreditCardAccountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.code1TextField || textField == self.code2TextField || textField == self.code3TextField || textField == self.code4TextField {
            return count <= 4
            
        }else if textField == self.dateYearTextField || textField == self.dateMonthField {
            return count <= 2
            
        }else if textField == self.nameTextField {
            return count <= 30
            
        }else if textField == self.cvvTextField {
            return count <= 4
        }
        return true
    }
    
    @objc func code1FieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 4 {
                code2TextField.becomeFirstResponder()
            }
            self.code1Complete = text.count == 4
            
        }else {
            self.code1Complete = false
        }
    }
    
    @objc func code2FieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 4 {
                code3TextField.becomeFirstResponder()
            }
            self.code2Complete = text.count == 4
            
        }else {
            self.code2Complete = false
        }
    }
    
    @objc func code3FieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 4 {
                code4TextField.becomeFirstResponder()
            }
            self.code3Complete = text.count == 4
            
        }else {
            self.code3Complete = false
        }
    }
    
    @objc func code4FieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 4 {
                dateMonthField.becomeFirstResponder()
            }
            self.code4Complete = text.count == 4
            
        }else {
            self.code4Complete = false
        }
    }
    
    @objc func dateMonthFieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 2 {
                dateYearTextField.becomeFirstResponder()
            }
            self.monthComplete = text.count == 2
            
        }else {
            self.monthComplete = false
        }
    }
    
    @objc func dateYearFieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 2 {
                nameTextField.becomeFirstResponder()
            }
            self.yearComplete = text.count == 2
            
        }else {
            self.yearComplete = false
        }
    }
    
    @objc func nameFieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 30 {
                cvvTextField.becomeFirstResponder()
            }
        }
    }
    
    @objc func cvvFieldDidChange(_ textField : UITextField) {
        
        if let text = textField.text, text.isNotEmpty {
            if text.count == 4 {
                view.endEditing(true)
            }
        }
    }
}

// MARK: - PRIVATE FUNCTIONS

extension CreditCardAccountViewController {
    
    private func isCardDataFull() -> Bool {
        return self.isCode1Full() && self.isCode2Full() && self.isCode3Full() && self.isCode4Full() && self.isMonthFull() && self.isYearFull() && self.isCvvFull()
    }
    
    private func isCardNumberFull() -> Bool {
        return self.isCode1Full() && self.isCode2Full() && self.isCode3Full() && self.isCode4Full()
    }
    
    private func isCode1Full() -> Bool {
        return self.code1Complete && self.code1TextField.text!.count == 4
    }
    private func isCode2Full() -> Bool {
        return self.code2Complete && self.code2TextField.text!.count == 4
    }
    
    private func isCode3Full() -> Bool {
        return self.code3Complete && self.code3TextField.text!.count == 4
    }
    
    private func isCode4Full() -> Bool {
        return self.code4Complete && self.code4TextField.text!.count == 4
    }
    
    private func isDateFull() -> Bool {
        return self.isMonthFull() && self.isYearFull()
    }
    
    private func isMonthFull() -> Bool {
        return self.monthComplete && self.dateMonthField.text!.count == 2
    }
    
    private func isYearFull() -> Bool {
        return self.yearComplete && self.dateYearTextField.text!.count == 2
    }
    
    private func isCvvFull() -> Bool {
        return self.cvvTextField.text!.count == 3 || self.cvvTextField.text!.count == 4
    }
    
    private func showHideCodeNumberError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.codeNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeNumberErrorLabel.isHidden = true
                    self.codeNumberContainerHeight.constant -= self.codeNumberErrorLabel.frame.height
                }
            }
        case .show:
            if self.codeNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeNumberErrorLabel.isHidden = false
                    self.codeNumberContainerHeight.constant += self.codeNumberErrorLabel.frame.height
                }
            }
        }
    }
    
    private func showHideExpiryError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.expiryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.expiryErrorLabel.isHidden = true
                    self.expiryContainerHeight.constant -= self.expiryErrorLabel.frame.height
                }
            }
        case .show:
            if self.expiryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.expiryErrorLabel.isHidden = false
                    self.expiryContainerHeight.constant += self.expiryErrorLabel.frame.height
                }
            }
        }
    }
    
    private func showHideNameError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.nameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.nameErrorLabel.isHidden = true
                    //                    self.nameContainerHeight.constant -= self.nameTextField.frame.height
                }
            }
        case .show:
            if self.nameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.nameErrorLabel.isHidden = false
                    //                    self.nameContainerHeight.constant += self.nameTextField.frame.height
                }
            }
        }
    }
    
    private func showHideCVVError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.cvvErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.cvvErrorLabel.isHidden = true
                    //                    self.cvvContainerHeight.constant -= self.cvvErrorLabel.frame.height
                }
            }
        case .show:
            if self.cvvErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.cvvErrorLabel.isHidden = false
                    //                    self.cvvContainerHeight.constant += self.cvvErrorLabel.frame.height
                }
            }
        }
    }
}
