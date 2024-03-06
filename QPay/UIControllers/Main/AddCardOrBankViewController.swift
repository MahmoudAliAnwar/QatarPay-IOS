//
//  AddCardOrBankViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

// api/NoqoodyUser/AddBankDetails
// api/NoqoodyUser/AddPaymentCard

class AddCardOrBankViewController: MainController {
    
    /// Card Outlets ...
    @IBOutlet weak var debitView: UIView!
    @IBOutlet weak var debitLabel: UILabel!
    @IBOutlet weak var debitImageView: UIImageView!
    
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var creditImageView: UIImageView!
    
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
    
    /// Bank Outlets ...
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var bankErrorsContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bankLabel: UILabel!
    @IBOutlet weak var bankImageView: UIImageView!
    
    @IBOutlet weak var countryListButton: UIButton!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNameErrorLabel: UILabel!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var bankNameErrorLabel: UILabel!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var accountNumberErrorLabel: UILabel!
    @IBOutlet weak var confirmAccountNumberTextField: UITextField!
    
    @IBOutlet weak var cardStackView: UIStackView!
    @IBOutlet weak var bankStackView: UIStackView!
    
    private var countryDropDown = DropDown.init()
    
    private var countryName: String?
    private var cardType: AccountType?
    
    private var code1Complete = false
    private var code2Complete = false
    private var code3Complete = false
    private var code4Complete = false
    
    private var monthComplete = false
    private var yearComplete = false
    
    private enum AccountType: String {
        case Debit = "Debit"
        case Credit = "Credit"
        case Bank = "Bank"
    }
    
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

extension AddCardOrBankViewController {
    
    func setupView() {
        code1TextField.delegate = self
        code2TextField.delegate = self
        code3TextField.delegate = self
        code4TextField.delegate = self
        nameTextField.delegate = self
        cvvTextField.delegate = self
        dateMonthField.delegate = self
        dateYearTextField.delegate = self
        
        code1TextField.addTarget(self, action: #selector(self.code1FieldDidChange(_:)), for: .editingChanged)
        code2TextField.addTarget(self, action: #selector(self.code2FieldDidChange(_:)), for: .editingChanged)
        code3TextField.addTarget(self, action: #selector(self.code3FieldDidChange(_:)), for: .editingChanged)
        code4TextField.addTarget(self, action: #selector(self.code4FieldDidChange(_:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(self.nameFieldDidChange(_:)), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(self.cvvFieldDidChange(_:)), for: .editingChanged)
        dateMonthField.addTarget(self, action: #selector(self.dateMonthFieldDidChange(_:)), for: .editingChanged)
        dateYearTextField.addTarget(self, action: #selector(self.dateYearFieldDidChange(_:)), for: .editingChanged)
        
        bankNameTextField.delegate = self
        accountNameTextField.delegate = self
        accountNumberTextField.delegate = self
        confirmAccountNumberTextField.delegate = self
        
        setToggleBtn()
        setupCountryDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddCardOrBankViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func debitCardAction(_ sender: UIButton) {
        
        setToggleBtn()
    }
    
    @IBAction func creditCardAction(_ sender: UIButton) {
        
        setToggleBtn(type: .Credit)
    }
    
    @IBAction func bankAccountAction(_ sender: UIButton) {
        
        setToggleBtn(type: .Bank)
    }
    
    @IBAction func countryListAction(_ sender: UIButton) {
        
//        self.countryDropDown.show()
        let vc = self.getStoryboardView(CountriesViewController.self)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func scanCardAction(_ sender: UIButton) {
        
//        let vc = Views.CardRecognizerViewController.storyboardView
//        self.present(vc, animated: true)
        
//        guard let vc = CreditCardScannerViewController.createViewController(withDelegate: self) else {
////            print("This device is incompatible with CardScan")
//            self.showErrorMessage("This device is incompatible with CardScan")
//            return
//        }
//        self.present(vc, animated: true)
    }
    
    @IBAction func addAccountAction(_ sender: UIButton) {
        
        if self.countryName == nil {
            self.showHideCountryError()
            
        }else if self.accountNameTextField.text!.isEmpty {
            self.showHideCountryError(action: .hide)
            self.showHideAccountNameError()
            
        }else if self.bankNameTextField.text!.isEmpty {
            self.showHideCountryError(action: .hide)
            self.showHideAccountNameError(action: .hide)
            self.showHideBankNameError()
            
        }else if self.accountNumberTextField.text!.isEmpty {
            self.showHideCountryError(action: .hide)
            self.showHideBankNameError(action: .hide)
            self.showHideAccountNameError(action: .hide)
            self.showHideAccountNumberError()
            
        }else {
            self.showHideCountryError(action: .hide)
            self.showHideBankNameError(action: .hide)
            self.showHideAccountNameError(action: .hide)
            self.showHideAccountNumberError(action: .hide)
            
            let bankName = self.bankNameTextField.text!
            let accountName = self.accountNameTextField.text!
            let accountNumber = self.accountNumberTextField.text!
            let accountConfirm = self.confirmAccountNumberTextField.text!
            
            if bankName.isNotEmpty, accountName.isNotEmpty, accountConfirm.isNotEmpty, accountNumber.isNotEmpty {
                
                if accountNumber == accountConfirm {
                    if let _ = self.countryName {
//                        let bank = BankObject(countryName: country, accountName: accountName, name: bankName, accountNumber: accountNumber)
//
//                        self.requestProxy.requestService()?.addBankDetails(bank: bank) { (status, response) in
//                            if status {
//                                if let resp = response {
//                                    self.showSuccessMessage(resp.message ?? "Bank Added successfully")
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                                    let vc = Views.MyCardsViewController.storyboardView
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
//                            }
                    }
                }
            }
        }
    }
    
    @IBAction func addCardAction(_ sender: UIButton) {
        
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
            
            if let _ = self.cardType,
               let code1 = self.code1TextField.text, code1.isNotEmpty,
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
                        
//                        var paymentCardType: PaymentCardType = .Credit
//                        switch type {
//                        case .Debit:
//                            paymentCardType = .Debit
//                        case .Credit:
//                            paymentCardType = .Credit
//                        case .Bank:
//                            break
//                        }
                        
                        let _ = "\(month) \(year)"
                        
//                        let card = CardObject.init(name: name, type: .Visa, number: fullCode, owner: name, expiryDate: date, cvv: cvv, paymentCardType: paymentCardType)
//
//                        self.requestProxy.requestService()?.addPaymentCard(card: card) { (status, response) in
//                            if status {
//                                if let resp = response {
//                                    self.showSuccessMessage(resp.message ?? "Card added successfully")
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
//                                    let vc = Views.MyCardsViewController.storyboardView
//                                    self.navigationController?.pushViewController(vc, animated: true)
//                                }
                    }
                }
            }
        }
    }
}

//// MARK: - CARD DELEGATE
//
//extension AddCardOrBankViewController: ScanDelegate {
//
//    func userDidSkip(_ scanViewController: ScanViewController) {
//        self.dismiss(animated: true)
//    }
//
//    func userDidCancel(_ scanViewController: ScanViewController) {
//        self.dismiss(animated: true)
//    }
//
//    func userDidScanCard(_ scanViewController: ScanViewController, creditCard: CreditCard) {
//
//        let number = creditCard.number
//        if number.isNotEmpty, number.count >= 16 {
//            self.code1TextField.text?.removeAll()
//            self.code2TextField.text?.removeAll()
//            self.code3TextField.text?.removeAll()
//            self.code4TextField.text?.removeAll()
//
//            let code = trimCode(number)
//            self.code1TextField.text = code[0]
//            self.code2TextField.text = code[1]
//            self.code3TextField.text = code[2]
//            self.code4TextField.text = code[3]
//
//            self.code1FieldDidChange(self.code1TextField)
//            self.code2FieldDidChange(self.code2TextField)
//            self.code3FieldDidChange(self.code3TextField)
//            self.code4FieldDidChange(self.code4TextField)
//        }
//
//        let expiryMonth = creditCard.expiryMonth
//        if let month = expiryMonth {
//            if month.count == 2 {
//                self.dateMonthField.text?.removeAll()
//
//                self.dateMonthField.text = month
//                self.dateMonthFieldDidChange(self.dateMonthField)
//            }
//        }
//
//        let expiryYear = creditCard.expiryYear
//        if let year = expiryYear {
//            if year.count == 2 {
//                self.dateYearTextField.text?.removeAll()
//
//                self.dateYearTextField.text = year
//                self.dateYearFieldDidChange(self.dateYearTextField)
//            }
//        }
//
//        if let name = creditCard.name, name.isNotEmpty {
//            self.nameTextField.text?.removeAll()
//
//            self.nameTextField.text = name
//        }
//
////        let card = "1 \(number), 2 \(expiryMonth ?? ""), 3 \(expiryYear ?? ""), 4 \(name ?? "")"
//
//        self.dismiss(animated: true)
//    }
//}

// MARK: - COUNTRY DELEGATE

extension AddCardOrBankViewController: CountryDelegate {
    
    func countrySelected(_ country: Country) {
        if let name = country.name {
            self.countryListButton.setTitle(name, for: .normal)
            self.countryName = name
            self.showHideCountryError(action: .hide)
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension AddCardOrBankViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
//        if request == .addPaymentCard ||
//            request == .addBankDetails {
//            showLoadingView(self)
//        }
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
//                        showMessage(exc, messageStatus: .Warning)
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

extension AddCardOrBankViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == accountNameTextField {
            self.bankNameTextField.becomeFirstResponder()
            
        }else if textField == bankNameTextField {
            self.accountNumberTextField.becomeFirstResponder()
            
        }else if textField == accountNumberTextField {
            self.confirmAccountNumberTextField.becomeFirstResponder()
            
        }else if textField == confirmAccountNumberTextField {
            self.view.endEditing(true)
        }
        
        return true
    }
    
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

extension AddCardOrBankViewController {
    
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
    
    private func setupCountryDropDown() {
        let appearance = DropDown.appearance()
        
        self.countryDropDown.anchorView = self.countryListButton
        
        self.countryDropDown.bottomOffset = CGPoint(x: 0, y: self.countryListButton.bounds.height)
        self.countryDropDown.direction = .bottom
        self.countryDropDown.dismissMode = .onTap
        
        appearance.cellHeight = self.countryListButton.bounds.height
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
        
        self.countryDropDown.selectionAction = { [weak self] (index, item) in
            self?.countryListButton.setTitle(item, for: .normal)
            self?.countryName = item
        }
    }
    
    private func fetchCountriesData() {
        
        var names = [String]()
        
        self.dispatchGroup.enter()
        self.requestProxy.requestService()?.countriesList { (status, list) in
            
            if let arr = list {
                arr.forEach { (cnt) in
                    if let name = cnt.name {
                        names.append(name)
                    }
                }
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.countryDropDown.dataSource = names
            self.countryDropDown.reloadAllComponents()
        })
    }
    
    private func showHideCountryError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.countryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.countryErrorLabel.isHidden = true
                    self.bankErrorsContainerHeight.constant -= self.countryErrorLabel.frame.height
                }
            }
        case .show:
            if self.countryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.countryErrorLabel.isHidden = false
                    self.bankErrorsContainerHeight.constant += self.countryErrorLabel.frame.height
                }
            }
        }
    }
    
    private func showHideAccountNameError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.accountNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.accountNameErrorLabel.isHidden = true
                    self.bankErrorsContainerHeight.constant -= self.accountNameErrorLabel.frame.height
                }
            }
        case .show:
            if self.accountNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.accountNameErrorLabel.isHidden = false
                    self.bankErrorsContainerHeight.constant += self.accountNameErrorLabel.frame.height
                }
            }
        }
    }
    
    private func showHideBankNameError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.bankNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.bankNameErrorLabel.isHidden = true
                    self.bankErrorsContainerHeight.constant -= self.bankNameErrorLabel.frame.height
                }
            }
        case .show:
            if self.bankNameErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.bankNameErrorLabel.isHidden = false
                    self.bankErrorsContainerHeight.constant += self.bankNameErrorLabel.frame.height
                }
            }
        }
    }
    
    private func showHideAccountNumberError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.accountNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.accountNumberErrorLabel.isHidden = true
                    self.bankErrorsContainerHeight.constant -= self.accountNumberErrorLabel.frame.height
                }
            }
        case .show:
            if self.accountNumberErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.accountNumberErrorLabel.isHidden = false
                    self.bankErrorsContainerHeight.constant += self.accountNumberErrorLabel.frame.height
                }
            }
        }
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
    
    private func setToggleBtn(type: AccountType = .Debit) {
        
        self.cardType = type
        
        switch type {
        case .Debit: // Payment Card Type is 2
            self.debitView.backgroundColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.debitLabel.textColor = .white
            self.debitImageView.image = UIImage.init(named: "ic_debit_card_white")
            
            self.creditView.backgroundColor = .white
            self.creditLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.creditImageView.image = UIImage.init(named: "ic_credit_card")
            
            self.bankView.backgroundColor = .white
            self.bankLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.bankImageView.image = UIImage.init(named: "ic_bank_add_card")
            
            self.cardStackView.isHidden = false
            self.bankStackView.isHidden = true
            
        case .Credit: // Payment Card Type is 2
            self.debitView.backgroundColor = .white
            self.debitLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.debitImageView.image = UIImage.init(named: "ic_debit_card")
            
            self.creditView.backgroundColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.creditLabel.textColor = .white
            self.creditImageView.image = UIImage.init(named: "ic_credit_card_white")
            
            self.bankView.backgroundColor = .white
            self.bankLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.bankImageView.image = UIImage.init(named: "ic_bank_add_card")
            
            self.cardStackView.isHidden = false
            self.bankStackView.isHidden = true
            
        case .Bank:
            
//            fetchCountriesData()
            
            self.debitView.backgroundColor = .white
            self.debitLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.debitImageView.image = UIImage.init(named: "ic_debit_card")
            
            self.creditView.backgroundColor = .white
            self.creditLabel.textColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.creditImageView.image = UIImage.init(named: "ic_credit_card")
            
            self.bankView.backgroundColor = UIColor.init(named: "light_red") ?? UIColor.init()
            self.bankLabel.textColor = .white
            self.bankImageView.image = UIImage.init(named: "ic_bank_add_card_white")
            
            self.cardStackView.isHidden = true
            self.bankStackView.isHidden = false
        }
    }
}
