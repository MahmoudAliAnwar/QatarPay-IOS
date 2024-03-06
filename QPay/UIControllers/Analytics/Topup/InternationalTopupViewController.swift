//
//  InternationalTopupViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/16/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class InternationalTopupViewController: EStoreTopupController {
    
    @IBOutlet weak var destinationCountryLabel: UILabel!
    @IBOutlet weak var destinationCountryErrorImageView: UIImageView!
    @IBOutlet weak var destinationCountryButton: UIButton!
    
    @IBOutlet weak var recipientCodeTextField: UITextField!
    @IBOutlet weak var recipientNumberTextField: UITextField!
    @IBOutlet weak var recipientNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountButton: UIButton!
    
    @IBOutlet weak var senderNumberTextField: UITextField!
    
    @IBOutlet weak var recipientFreeTextView: UITextView!
    
    private let descPlaceholder = "Enter Message"
    
    private var msdnObject: MSISDN?
    private var transfer: Transfer?

    private var selectedCountry: Country?
    
    private var maxMobileNumberDigits: Int = 10
    
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

extension InternationalTopupViewController {
    
    func setupView() {
        self.recipientNumberTextField.delegate = self
//        self.recipientFreeTextView.delegate = self
//        self.recipientFreeTextView.textColor = .lightGray
//        self.recipientFreeTextView.text = self.descPlaceholder
        
        self.recipientCodeTextField.isEnabled = false
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension InternationalTopupViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryDropDownAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(CountriesViewController.self)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @IBAction func selectAmountAction(_ sender: UIButton) {
        guard let object = self.msdnObject else {
            self.showErrorMessage("Please, enter valid recipient number")
            return
        }
        
        let vc = self.getStoryboardView(SelectTopupAmountViewController.self)
        vc.delegate = self
        vc.object = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        guard let trans = self.transfer else { return }
        
        let vc = self.getStoryboardView(ConfirmPinCodeViewController.self)
        vc.data = trans
        vc.updateViewElementDelegate = self
        self.present(vc, animated: true)
    }
}

// MARK: - COUNTRY DELEGATE

extension InternationalTopupViewController: CountryDelegate {
    
    func countrySelected(_ country: Country) {
        self.selectCountry(country)
    }
}

// MARK: - REQUESTS DELEGATE

extension InternationalTopupViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .msdnRequest ||
            request == .reserveIDRequest {
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

// MARK: - SELECT AMOUNT DELEGATE

extension InternationalTopupViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        if view is ConfirmPinCodeViewController {
            guard status == true,
                  let message = data as? String else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.showSuccessMessage(message)
            }
        }
    }
}

// MARK: - SELECT AMOUNT DELEGATE

extension InternationalTopupViewController: SelectTopupAmountViewControllerDelegate {
    
    func didSelectAmount(product: MSISDNProduct) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            guard let countryCode = self.recipientCodeTextField.text,
                  let object = self.msdnObject,
                  let cost = Double(product._costPrice) else {
                return
            }
            
            self.requestProxy.requestService()?.reserveIDRequest(
                requestID: object._requestID.description,
                referenceNumber: "NA",
                costPrice: cost,
                productCode: product._productList,
                msidn: object._msisdn,
                countryCode: countryCode,
                completion: { (status, baseResponse) in
                    guard status, let response = baseResponse else { return }
                    
                    var trans = Transfer()
                    trans.accessToken = response.accessToken ?? ""
                    trans.verificationID = response.verificationID ?? ""
                    trans.requestID = response.topupRequestID ?? ""
                    trans.amount = response.amount ?? -1.0
                    
                    self.transfer = trans
                    self.showSuccessMessage("You are ready now for confirm topup...")
                })
        }
    }
}

// MARK: - TEXT FIELD DELEGATE

extension InternationalTopupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.recipientNumberTextField {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            guard let country = self.selectedCountry else {
                self.showErrorMessage("Please, select destination country")
                return false
            }
            
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            
            if count == self.maxMobileNumberDigits {
                self.view.endEditing(true)
                guard let code = country.code else { return false }
                
                let phone = "\(code)\(textFieldText)\(string)"
                textField.text! += string
                
                self.requestProxy.requestService()?.msdnRequest(msidn: phone, countryCode: code, completion: { (status, object) in
                    if status, let obj = object {
                        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                            self.msdnObject = obj
                            self.showSuccessMessage("You are ready now for select amount...")
                        }
                    }
                })
            }
            return count <= self.maxMobileNumberDigits
        }
        return false
    }
}

// MARK: - TEXT VIEW DELEGATE

extension InternationalTopupViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.descPlaceholder
            textView.textColor = .lightGray
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InternationalTopupViewController {
    
    private func selectCountry(_ country: Country) {
        guard let name = country.name else { return }
        
        self.destinationCountryLabel.text = name
        self.selectedCountry = country
        self.destinationCountryErrorImageView.image = .none
        
        self.recipientCodeTextField.text = country.code ?? ""
    }
}
