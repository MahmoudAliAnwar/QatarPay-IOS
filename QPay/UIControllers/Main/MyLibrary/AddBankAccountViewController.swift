//
//  AddBankAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class AddBankAccountViewController: MainController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryErrorImageView: UIImageView!
    @IBOutlet weak var countryButton: UIButton!

    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var accountNameErrorImageView: UIImageView!
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankNameErrorImageView: UIImageView!
    @IBOutlet weak var bankNameButton: UIButton!

    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var accountNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var swiftCodeTextField: UITextField!
    @IBOutlet weak var swiftCodeErrorImageView: UIImageView!
    
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var ibanErrorImageView: UIImageView!
    
    var viewType: String?
    var bank: Bank?
    
    private var countryDropDown = DropDown()
    private var bankNameDropDown = DropDown()

    private var bankNames = [BankName]()
    
    private var countrySelected: String?
    private var bankNameSelected: BankName?
    
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
        
        self.requestProxy.requestService()?.delegate = self
    }
}

extension AddBankAccountViewController {
    
    func setupView() {
        self.setupDropDownAppearance()
        self.setupCountryDropDown()
        self.setupBankNameDropDown()
    }
    
    func localized() {
    }
    
    func setupData() {
        
        if let type = self.viewType {
            self.viewTypeLabel.text = type
        }
        
        self.setIsUpdateView(self.bank != nil)
        
        if let bnk = bank {
            if let country = bnk.countryName {
                self.selectCountry(country)
            }
            self.accountNameTextField.text = bnk.accountName ?? ""
            if let name = bnk.name {
                self.selectBankName(name)
            }
            self.accountNumberTextField.text = bnk.accountNumber ?? ""
            self.swiftCodeTextField.text = bnk.swiftCode ?? ""
            self.ibanTextField.text = bnk.iban ?? ""
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension AddBankAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        guard self.checkViewFieldsErrors() else { return }
        guard let country = countrySelected,
              let accountName = self.accountNameTextField.text, accountName.isNotEmpty,
              let bankName = self.bankNameSelected,
              let accountNumber = self.accountNumberTextField.text, accountNumber.isNotEmpty,
              let swiftCode = self.swiftCodeTextField.text, swiftCode.isNotEmpty,
              let iban = self.ibanTextField.text, iban.isNotEmpty else {
            return
        }
        
        var finalBank = Bank()
        finalBank.countryName = country
        finalBank.accountName = accountName
        finalBank.accountNumber = accountNumber
        finalBank.iban = iban
        finalBank.swiftCode = swiftCode
        
        if let bnk = self.bank {
            guard let bankID = bnk.iD else { return }
            self.requestProxy.requestService()?.updateBankDetails(bankID, bank: finalBank, bankName: bankName, completion: { (status, response) in
                guard status else { return }
            })
            
        }else {
            self.requestProxy.requestService()?.addBankDetails(bank: finalBank, bankName: bankName) { (status, response) in
                guard status else { return }
            }
        }
    }
    
    @IBAction func countryAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CountriesViewController.self)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func bankNameAction(_ sender: UIButton) {
        self.bankNameDropDown.show()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        
        guard let bnk = self.bank,
              let bankID = bnk.iD else {
            return
        }
        self.showConfirmation(message: "you want to delete bank account") {
            self.requestProxy.requestService()?.deleteBank(bankID: bankID) { (status, response) in
                guard status else { return }
            }
        }
    }
}

// MARK: - COUNTRY DELEGATE

extension AddBankAccountViewController: CountryDelegate {
    
    func countrySelected(_ country: Country) {
        guard let name = country.name else { return }
        self.selectCountry(name)
    }
}

// MARK: - REQUESTS DELEGATE

extension AddBankAccountViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .addBankDetails ||
            request == .deleteBank ||
            request == .updateBankDetails {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                if let response = data as? BaseResponse {
                    self.showSuccessMessage(response.message ?? "")
                    
                    if request == .addBankDetails || request == .deleteBank || request == .updateBankDetails {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
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

extension AddBankAccountViewController {
    
    private func checkViewFieldsErrors() -> Bool {
        
        let isCountryNotEmpty = self.countrySelected != nil
        self.showHideCountryError(isCountryNotEmpty)
        
        let isAccountNameNotEmpty = self.accountNameTextField.text!.isNotEmpty
        self.showHideAccountNameError(isAccountNameNotEmpty)
        
        let isBankNameNotEmpty = self.bankNameSelected != nil
        self.showHideBankNameError(isBankNameNotEmpty)
        
        let isAccountNumberNotEmpty = self.accountNumberTextField.text!.isNotEmpty
        self.showHideAccountNumberError(isAccountNumberNotEmpty)
        
        let isSwiftCodeNotEmpty = self.swiftCodeTextField.text!.isNotEmpty
        self.showHideSwiftCodeError(isSwiftCodeNotEmpty)
        
        let isIFSCNotEmpty = self.ibanTextField.text!.isNotEmpty
        self.showHideIFSCError(isIFSCNotEmpty)
        
        return isCountryNotEmpty && isAccountNameNotEmpty && isBankNameNotEmpty && isAccountNumberNotEmpty && isSwiftCodeNotEmpty && isIFSCNotEmpty
    }
    
    private func showHideCountryError(_ isNotEmpty: Bool) {
        self.countryErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideAccountNameError(_ isNotEmpty: Bool) {
        self.accountNameErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideBankNameError(_ isNotEmpty: Bool) {
        self.bankNameErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideAccountNumberError(_ isNotEmpty: Bool) {
        self.accountNumberErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideSwiftCodeError(_ isNotEmpty: Bool) {
        self.swiftCodeErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func showHideIFSCError(_ isNotEmpty: Bool) {
        self.ibanErrorImageView.image = isNotEmpty ? .none : .errorCircle
    }
    
    private func setupDropDownAppearance() {
        
        let appearance = DropDown.appearance()
        appearance.cellHeight = 36
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.8
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = appBackgroundColor
    }
    
    private func setupCountryDropDown() {
        
        self.countryDropDown.anchorView = self.countryButton
        
        self.countryDropDown.topOffset = CGPoint(x: 0, y: self.countryButton.bounds.height)
        self.countryDropDown.direction = .any
        self.countryDropDown.dismissMode = .automatic
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.countriesList { (status, countryList) in
            guard status else { return }
            
            let countries = countryList ?? []
            
            for country in countries {
                if let name = country.name {
                    self.countryDropDown.dataSource.append(name)
                }
            }
            self.dispatchGroup.leave()
        }
        
        self.dispatchGroup.notify(queue: .main) {
            if let bnk = self.bank, let country = bnk.countryName {
                self.selectCountry(country)
            }
        }
        
        self.countryDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectCountry(item)
        }
    }
    
    private func selectCountry(_ country: String) {
        
        for (index, value) in self.countryDropDown.dataSource.enumerated() {
            if country == value {
                self.countryDropDown.selectRow(index)
                self.countryLabel.text = value
                self.countrySelected = value
                self.countryErrorImageView.image = .none
                break
            }
        }
    }
    
    private func setupBankNameDropDown() {
        
        self.bankNameDropDown.anchorView = self.bankNameButton
        
        self.bankNameDropDown.topOffset = CGPoint(x: 0, y: self.bankNameButton.bounds.height)
        self.bankNameDropDown.direction = .any
        self.bankNameDropDown.dismissMode = .automatic
        
        self.dispatchGroup.enter()
        
        self.requestProxy.requestService()?.getBankNameList { (status, bankNames) in
            guard status else { return }
            
            let names = bankNames ?? []
            self.bankNames = names
            
            for name in names {
                if let text = name.text {
                    self.bankNameDropDown.dataSource.append(text)
                }
            }
            
            self.dispatchGroup.leave()
        }
        self.dispatchGroup.notify(queue: .main) {
            if let bnk = self.bank, let name = bnk.name {
                self.selectBankName(name)
            }
        }
        
        self.bankNameDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectBankName(item)
        }
    }
    
    private func selectBankName(_ name: String) {
        
        for (index, value) in self.bankNames.enumerated() {
            if name == value.text {
                self.bankNameDropDown.selectRow(index)
                self.bankNameLabel.text = name
                self.bankNameSelected = value
                self.bankNameErrorImageView.image = .none
                break
            }
        }
    }
    
    private func setIsUpdateView(_ status: Bool) {
        self.showHideDeleteButton(status)
        self.isUpdateTitle(status)
    }
    
    private func showHideDeleteButton(_ status: Bool) {
        self.deleteImageView.isHidden = !status
        self.deleteButton.isHidden = !status
    }
    
    private func isUpdateTitle(_ status: Bool) {
        self.titleLabel.text = status ? "Update" : "Add New Data"
    }
}
