//
//  RequestMoneyViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit
import DropDown

class RequestMoneyViewController: MainController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var scrollViewContainerViewDesign: ViewDesign!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountTopViewDesign: ViewDesign!
    @IBOutlet weak var amountBottomViewDesign: ViewDesign!
    
    @IBOutlet weak var mobileViewsStackView: UIStackView!
    
    @IBOutlet weak var mobileArrowImageView: UIImageView!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var mobileNumberRequestView: UIView!
    @IBOutlet weak var qatarFlagView: UIView!
    
    @IBOutlet weak var mobileBeneficiaryView: UIView!
    @IBOutlet weak var beneficiaryImageView: UIImageView!
    @IBOutlet weak var beneficiaryMobileNameLabel: UILabel!
    @IBOutlet weak var beneficiaryQPANLabel: UILabel!
    @IBOutlet weak var changeUserButton: UIButton!
    
    @IBOutlet weak var emailArrowImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailRequestView: UIView!
    
    @IBOutlet weak var qpanArrowImageView: UIImageView!
    @IBOutlet weak var qpan1TextField: UITextField!
    @IBOutlet weak var qpan2TextField: UITextField!
    @IBOutlet weak var qpan3TextField: UITextField!
    @IBOutlet weak var qpan4TextField: UITextField!
    @IBOutlet weak var qpanErrorLabel: UILabel!
    @IBOutlet weak var qpanRequestView: UIView!
    
    @IBOutlet weak var beneficiaryArrowImageView: UIImageView!
    @IBOutlet weak var beneficiaryNameLabel: UILabel!
    @IBOutlet weak var beneficiaryErrorLabel: UILabel!
    @IBOutlet weak var beneficiaryRequestView: UIView!
    @IBOutlet weak var beneficiaryDropDownButton: UIButton!
    
    @IBOutlet weak var qrCodeArrowImageView: UIImageView!
    @IBOutlet weak var qrCodeRequestView: UIView!
    
    private var isCompleteMobile = false {
        willSet {
            self.changeMobileErrorMessage("Enter valid mobile number")
            self.showHideMobileError(action: newValue ? .hide : .show)
        }
    }
    
    private var isCompleteEmail = false {
        willSet {
            self.showHideEmailError(action: newValue ? .hide : .show)
        }
    }
    
    private var requestBySelected: RequestBy?
    
    private enum RequestBy {
        case Mobile
        case Email
        case QPAN
        case QRCode
        case Beneficiary
    }
    
    private let downArrow: UIImage = .ic_arrow_down_transfer
    private let rightArrow: UIImage = .ic_arrow_right_transfer
    
    private var isCompleteQPan1 = false
    private var isCompleteQPan2 = false
    private var isCompleteQPan3 = false
    private var isCompleteQPan4 = false
    
    private let imagePicker = UIImagePickerController()
    
    private let beneficiaryDropDown = DropDown()
    private var beneficiarySelectedIndex: Int = -1
    private var selectedBeneficiary: Beneficiary?
    private var beneficiaries = [Beneficiary]()
    private var mobileBeneficiaries: [Beneficiary]?
    
    private var defaultAmount: Double = 10
    private var isCorrectAmount: Bool = true
    private var amountMessage: String = "Amount should be greater than 10 noqs"
    
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
        
        self.setupBeneficiaryDropDown()
        
        self.requestProxy.requestService()?.getUserBalance { (status, balance) in
            guard status,
                  let blnc = balance else {
                return
            }
            self.balanceLabel.text = blnc.formatNumber()
        }
    }
}

extension RequestMoneyViewController {
    
    func setupView() {
        self.scrollViewContainerViewDesign.setViewCorners([.topLeft, .topRight])
        self.amountTopViewDesign.setViewCorners([.topLeft, .topRight])
        self.amountBottomViewDesign.setViewCorners([.bottomLeft, .bottomRight])
        
        self.amountTextField.delegate = self
        self.amountTextField.text = "\(self.defaultAmount)"
        
        self.mobileTextField.delegate = self
        self.qpan1TextField.delegate = self
        self.qpan2TextField.delegate = self
        self.qpan3TextField.delegate = self
        self.qpan4TextField.delegate = self
        
        self.imagePicker.delegate = self
        
        self.mobileTextField.addTarget(self, action: #selector(self.mobileFieldDidChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: .editingChanged)
        
        self.qpan1TextField.addTarget(self, action: #selector(self.qpan1FieldDidChange(_:)), for: .editingChanged)
        self.qpan2TextField.addTarget(self, action: #selector(self.qpan2FieldDidChange(_:)), for: .editingChanged)
        self.qpan3TextField.addTarget(self, action: #selector(self.qpan3FieldDidChange(_:)), for: .editingChanged)
        self.qpan4TextField.addTarget(self, action: #selector(self.qpan4FieldDidChange(_:)), for: .editingChanged)
        
        self.qatarFlagView.roundCorners([.bottomLeft, .topLeft], radius: self.qatarFlagView.height/2)
        
        self.setupDropDownAppearance()
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension RequestMoneyViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeUserAction(_ sender: UIButton) {
        self.showSelectBeneficiaryPopup()
    }
    
    @IBAction func beneficiaryDropDownAction(_ sender: UIButton) {
        self.beneficiaryDropDown.show()
    }
    
    @IBAction func addBeneficiaryAction(_ sender: UIButton) {
        let vc = self.getStoryboardView(AddBeneficiaryViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        guard let amountString = self.amountTextField.text, amountString.isNotEmpty else {
            self.showErrorMessage("Please Enter Noqs")
            return
        }
        guard let amount = Double(amountString) else { return }
        
        guard isCorrectAmount else {
            self.showErrorMessage(amountMessage)
            return
        }
        
        guard let type = self.requestBySelected else {
            self.showErrorMessage("Please, Select one of request types")
            return
        }
        
        switch type {
        case .Mobile:
            guard self.isCompleteMobile == true else { return }
            guard let mobile = self.mobileTextField.text, mobile.isNotEmpty else {
                self.showHideMobileError()
                return
            }
            self.showHideMobileError(action: .hide)
            
            guard let ben = self.selectedBeneficiary,
                  let qpan = ben.qpan else {
                return
            }
            
            self.sendQPANRequest(amount, qpanNumber: qpan)
            break
            
        case .Email:
            guard let email = self.emailTextField.text, email.isNotEmpty else {
                self.showHideEmailError()
                return
            }
            self.showHideEmailError(action: .hide)
            self.sendEmailRequest(amount, email: email)
            break
            
        case .QPAN:
            if self.isQPanNumberFull() {
                self.showHideQPanError(action: .hide)
                
                let number = "\(self.qpan1TextField.text!)\(self.qpan2TextField.text!)\(self.qpan3TextField.text!)\(self.qpan4TextField.text!)"
                self.sendQPANRequest(amount, qpanNumber: number)
                
            } else {
                self.showHideQPanError()
            }
            break
            
        case .QRCode:
            break
            
        case .Beneficiary:
            guard self.beneficiarySelectedIndex >= 0 else {
                self.showErrorMessage("Please, Select Beneficiary")
                return
            }
            
            let ben = self.beneficiaries[self.beneficiarySelectedIndex]
            self.sendEmailRequest(amount, email: ben._emailAddress)
            break
        }
    }
    
    @IBAction func scanQRCodeConfirmAction(_ sender: UIButton) {
        
        guard let amountString = self.amountTextField.text, amountString.isNotEmpty else {
            self.showErrorMessage("Please Enter Noqs")
            return
        }
        guard let _ = Double(amountString) else { return }
        
        let vc = self.getStoryboardView(QRScannerViewController.self)
        vc.updateElementDelegate = self
        vc.isVendexView = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loadQRCodeConfirmAction(_ sender: UIButton) {
        
        guard let amountString = self.amountTextField.text, amountString.isNotEmpty else {
            self.showErrorMessage("Please Enter Noqs")
            return
        }
        guard let _ = Double(amountString) else { return }
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func mobileNumberAction(_ sender: UIButton) {
        self.showHideRequestTo(.Mobile)
    }
    
    @IBAction func emailAddressAction(_ sender: UIButton) {
        self.showHideRequestTo(.Email)
    }
    
    @IBAction func QPanAction(_ sender: UIButton) {
        self.showHideRequestTo(.QPAN)
    }
    
    @IBAction func QRCodeAction(_ sender: UIButton) {
        self.showHideRequestTo(.QRCode)
    }
    
    @IBAction func BeneficiaryAction(_ sender: UIButton) {
        self.showHideRequestTo(.Beneficiary)
    }
}

// MARK: - UPDATE VIEW ELEMENT DELEGATE

extension RequestMoneyViewController: UpdateViewElement {
    
    func elementUpdated(fromSourceView view: UIViewController, status: Bool, data: Any?) {
        
        if view is QRScannerViewController {
            guard let code = data as? String,
                  let amountString = self.amountTextField.text, amountString.isNotEmpty,
                  let amount = Double(amountString) else {
                return
            }
            
            self.sendQRCodeRequest(amount, qrCode: code)
        }
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension RequestMoneyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        // print out the image size as a test
//        print(image.size)
        
        guard let features = image.detectQRCode(), !features.isEmpty else {
            self.showErrorMessage("QR-code invalid, please try again")
            return
        }
        for case let row as CIQRCodeFeature in features {
            if let ammount = self.amountTextField.text, ammount.isNotEmpty,
               let code = row.messageString,
               let amm = Double(ammount) {
                
                self.sendQRCodeRequest(amm, qrCode: code)
                break
            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension RequestMoneyViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .requestMoneyByEmail  ||
            request == .requestMoneyByPhone ||
            request == .requestMoneyByQPAN  ||
            request == .requestMoneyByQR ||
            request == .getBeneficiariesByPhone {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(let data):
                if request == .requestMoneyByPhone  ||
                    request == .requestMoneyByEmail ||
                    request == .requestMoneyByQPAN  ||
                    request == .requestMoneyByQR {
                    
                    guard let transfer = data as? Transfer else { return }
                    guard transfer.success == true else { return }
                    
                    self.showSuccessMessage(transfer.message ?? "Request money completed successfully")
                }
                break
                
            case .Failure(let errorType):
                switch errorType {
                case .Exception(let exc):
                    guard exc == "5858" else {
                        if showUserExceptions {
                            self.showErrorMessage(exc)
                        }
                        return
                    }
                    let vc = self.getStoryboardView(DataRegisterErrorViewController.self)
                    vc.errorType = .Email
                    vc.amount = self.checkAmountAndReturn()
                    self.present(vc, animated: true)
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

extension RequestMoneyViewController: UITextFieldDelegate {
    
    @objc func qpan1FieldDidChange(_ textField : UITextField) {
        
        guard let text = textField.text, text.isNotEmpty else { return }
        
        let condition = text.count == 4
        if condition {
            qpan2TextField.becomeFirstResponder()
        }
        self.isCompleteQPan1 = condition
    }
    
    @objc func qpan2FieldDidChange(_ textField : UITextField) {
        
        guard let text = textField.text, text.isNotEmpty else { return }
        
        let condition = text.count == 4
        if condition {
            qpan3TextField.becomeFirstResponder()
        }
        self.isCompleteQPan2 = condition
    }
    
    @objc func qpan3FieldDidChange(_ textField : UITextField) {
        
        guard let text = textField.text, text.isNotEmpty else { return }
        
        let condition = text.count == 4
        if condition {
            qpan4TextField.becomeFirstResponder()
        }
        self.isCompleteQPan3 = condition
    }
    
    @objc func qpan4FieldDidChange(_ textField : UITextField) {
        
        guard let text = textField.text, text.isNotEmpty else { return }
        
        let condition = text.count == 4
        if condition {
            view.endEditing(true)
        }
        self.isCompleteQPan4 = condition
    }
    
    @objc func mobileFieldDidChange(_ textField : UITextField) {
        
    }
    
    @objc func emailFieldDidChange(_ textField : UITextField) {
        
//        guard let text = textField.text, text.isNotEmpty else {
//            self.isCompleteEmail = false
//            return
//        }
//
//        if isValidEmail(text) {
//            self.requestProxy.requestService()?.checkEmailRegisterd(email: text) { (status) in
//                self.isCompleteEmail = status
//            }
//        }else {
//            self.isCompleteEmail = false
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == self.amountTextField,
              let text = textField.text else {
            return
        }
        
        guard text.isNotEmpty else {
            self.showErrorMessage(self.amountMessage)
            return
        }
        guard let amount = Double(text) else { return }
        
        self.isCorrectAmount = amount >= 10
        
        if amount < 10 {
            self.showErrorMessage(self.amountMessage)
            
        } else {
            guard let requestType = self.requestBySelected,
                  requestType == .Mobile else {
                return
            }
            guard let mobile = self.mobileTextField.text,
                  mobile.isNotEmpty else {
                return
            }
            guard mobile.count == 8 else { return }
            
            self.handleMobileNumberConfirmation(mobile)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField == self.amountTextField {
            return count <= ammountFieldsMaxLength
            
        }else if textField == self.mobileTextField {
            self.isCompleteMobile = false
            if self.mobileBeneficiaryView.isHidden.toggleAndReturn() {
                self.setIsHideMobileBeneficiaryView(true)
            }
            if count == 8 {
                let mobile = "\(textFieldText)\(string)"
                textField.text! += string
                
                self.handleMobileNumberConfirmation(mobile)
            }
            return count <= 8
            
        }else if textField == self.qpan1TextField ||
                    textField == self.qpan2TextField ||
                    textField == self.qpan3TextField ||
                    textField == self.qpan4TextField {
            return count <= 4
        }
        return true
    }
}

// MARK: - SELECT BENEFICIARY DELEGATE

extension RequestMoneyViewController: SelectBeneficiaryPopupDelegate {
    
    func didSelectBeneficiary(_ beneficiary: Beneficiary) {
        self.setMobileBeneficiaryData(beneficiary)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension RequestMoneyViewController {
    
    // QRCode for niji account =>> eyJVc2VyU2VxdWVuY2UiOjQ1LCJFbWFpbCI6ImJkb0BxbW9iaWxlbWUuY29tIiwiUm9sZSI6IkFjY291bnRzIiwiVXNlck5hbWUiOiJiZG9AcW1vYmlsZW1lLmNvbSIsIkNvbXBhbnkiOiJOQSIsIkNvdW50cnlJRCI6MCwiVXNlclN0YXR1c0lEIjoyLCJGdWxsTmFtZSI6Ik5pamkiLCJQaG9uZU51bWJlciI6bnVsbCwiRmF4IjoiTkEiLCJDaXR5IjoiTkEiLCJBZGRyZXNzIjoiaG9tIiwiSW1hZ2VVUkwiOiJodHRwczovL2FwaS5xYXRhcnBheS5jb20vQVBJL1VwbG9hZHNcXFJlZ2lzdGVyYXRpb25cXGltYWdlcGF0aC8yMDIwLTExLTI5XzExLTQwLTIyX1VzZXItZmlsZS5qcGciLCJNb2JpbGUiOiI1NTU5MzA1OCIsIldlYnNpdGUiOm51bGwsIlVzZXJTdGF0dXMiOiJBY3RpdmUiLCJFbWFpbFZlcmlmaWVkIjp0cnVlLCJMYXN0TmFtZSI6IkNoYXRoYW5rYW5kYXRoIiwiRmlyc3ROYW1lIjpudWxsLCJSb2xlTm1lIjpudWxsLCJQaG9uZU51bWJlckNvbmZpcm1lZCI6dHJ1ZSwiVGVsZXBob25lIjoiNTU1OTMwNTgiLCJQaW5FbmFibGVkIjp0cnVlLCJRSURWZXJpZmllZCI6dHJ1ZSwiUUlETnVtYmVyIjoiMTIzNDU2NzIxMTEiLCJQYXNzcG9ydE51bWJlciI6IjEyM252Z2hqIiwiQnVpbGRpbmdOdW1iZXIiOiIyMDYiLCJTdHJlZXROdW1iZXIiOiIyMDAiLCJab25lIjoiOTEiLCJMb25naXR1ZGUiOiI1MS41NzU2MjU2MjYzIiwiTGF0aXR1ZGUiOiIyNS4xNzI1MjUzODU4IiwiUGFzc3BvcnRWZXJpZmllZCI6ZmFsc2V9
    
    private func handleMobileNumberConfirmation(_ mobile: String) {
        self.view.endEditing(true)
        
        self.showLoadingView(self)
        
        self.requestProxy.requestService()?.checkPhoneRegisterd(phoneNumber: mobile) { (status) in
            self.hideLoadingView()
            self.isCompleteMobile = status
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard status else {
                    self.changeMobileErrorMessage("The Mobile number is not registerd in Qatar Pay")
                    let vc = self.getStoryboardView(DataRegisterErrorViewController.self)
                    vc.errorType = .Mobile
                    vc.amount = self.checkAmountAndReturn()
                    self.present(vc, animated: true)
                    return
                }
                
                self.requestProxy.requestService()?.getBeneficiariesByPhone(mobile, completion: { (status, responseList) in
                    guard status == true else { return }
                    
                    let list = responseList ?? []
                    let isHasManyUsers = list.count > 1
                    self.isEnabledChangeButton(isHasManyUsers)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                        if isHasManyUsers {
                            self.mobileBeneficiaries = list
                            self.showSelectBeneficiaryPopup()
                        } else {
                            guard let beneficiary = list.first else { return }
                            self.setMobileBeneficiaryData(beneficiary)
                        }
                    }
                })
            }
        }
    }
    
    private func checkAmountAndReturn() -> String {
        
        let defaultAmountString: String = "\(self.defaultAmount)"
        
        guard let amount = self.amountTextField.text else { return defaultAmountString }
        if amount.isEmpty {
            self.amountTextField.text = defaultAmountString
            return defaultAmountString
        } else {
            return amount
        }
    }
    
    private func sendQRCodeRequest(_ amount: Double, qrCode: String) {
        self.requestProxy.requestService()?.requestMoneyByQR(amount: amount, QR: qrCode) { (status, transfer) in
            guard status else { return }
        }
    }
    
    // QPAN for mohammed account =>> 1456456789070002
    private func sendQPANRequest(_ amount: Double, qpanNumber: String) {
        self.requestProxy.requestService()?.requestMoneyByQPAN(amount: amount, qpanNumber: qpanNumber) { (status, response) in
            guard status == true else { return }
        }
    }
    
    private func showSelectBeneficiaryPopup() {
        
        guard let list = self.mobileBeneficiaries,
              let mobile = mobileTextField.text, mobile.isNotEmpty else {
            return
        }
        let vc = self.getStoryboardView(SelectBeneficiaryPopupViewController.self)
        vc.beneficiaries = list
        vc.mobile = mobile
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func setMobileBeneficiaryData(_ beneficiary: Beneficiary) {
        self.selectedBeneficiary = beneficiary
        UIView.animate(withDuration: 0.3) {
            self.setIsHideMobileBeneficiaryView(false)
            
        } completion: { (isComlete) in
            self.beneficiaryMobileNameLabel.text = beneficiary._fullName
            self.beneficiaryQPANLabel.text = beneficiary._qpan
            
            guard let imageURL = beneficiary.profilePicture else { return }
            imageURL.getImageFromURLString { (status, image) in
                guard status else { return }
                self.beneficiaryImageView.image = image
            }
        }
    }
    
    private func setIsHideMobileBeneficiaryView(_ status: Bool) {
        self.mobileBeneficiaryView.isHidden = status
    }
    
    private func isEnabledChangeButton(_ isEnable: Bool) {
        self.changeUserButton.isEnabled = isEnable
        self.changeUserButton.setTitleColor(isEnable ? .appBackgroundColor : .mLabel_Light_Gray, for: .normal)
    }
    
    private func sendEmailRequest(_ amount: Double, email: String) {
        self.requestProxy.requestService()?.requestMoneyByEmail(ammount: amount, email: email) { (status, transfer) in
            guard status else { return }
        }
    }
    
    private func isQPanNumberFull() -> Bool {
        return self.isQPan1Full() && self.isQPan2Full() && self.isQPan3Full() && self.isQPan4Full()
    }
    
    private func isQPan1Full() -> Bool {
        return self.isCompleteQPan1 && self.qpan1TextField.text!.count == 4
    }
    private func isQPan2Full() -> Bool {
        return self.isCompleteQPan2 && self.qpan2TextField.text!.count == 4
    }
    
    private func isQPan3Full() -> Bool {
        return self.isCompleteQPan3 && self.qpan3TextField.text!.count == 4
    }
    
    private func isQPan4Full() -> Bool {
        return self.isCompleteQPan4 && self.qpan4TextField.text!.count == 4
    }
    
    private func showHideEmailError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.emailErrorLabel.isHidden = true
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
        case .show:
            if self.emailErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.emailErrorLabel.isHidden = false
                    self.isCompleteEmail = self.emailErrorLabel.isHidden
                }
            }
        }
    }
    
    private func changeMobileErrorMessage(_ message: String) {
        self.mobileErrorLabel.text = message
    }
    
    private func showHideMobileError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.mobileErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileErrorLabel.isHidden = true
                    self.isCompleteMobile = self.mobileErrorLabel.isHidden
                }
            }
        case .show:
            if self.mobileErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.mobileErrorLabel.isHidden = false
                    self.isCompleteMobile = self.mobileErrorLabel.isHidden
                }
            }
        }
    }
    
    private func showHideQPanError(action: ViewErrorsAction = .show) {
        
        switch action {
        case .hide:
            if !self.qpanErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qpanErrorLabel.isHidden = true
                }
            }
        case .show:
            if self.qpanErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qpanErrorLabel.isHidden = false
                }
            }
        }
    }
    
    private func showHideBeneficiaryError(action: ViewErrorsAction = .show) {
        switch action {
        case .hide:
            if !self.beneficiaryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qpanErrorLabel.isHidden = true
                }
            }
        case .show:
            if self.beneficiaryErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.qpanErrorLabel.isHidden = false
                }
            }
        }
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
    
    private func setupBeneficiaryDropDown() {
        self.beneficiaryDropDown.anchorView = self.beneficiaryDropDownButton
        
        self.beneficiaryDropDown.topOffset = CGPoint(x: 0, y: self.beneficiaryDropDownButton.bounds.height)
        self.beneficiaryDropDown.direction = .any
        self.beneficiaryDropDown.dismissMode = .automatic
        
        let group = DispatchGroup()
        group.enter()
        self.requestProxy.requestService()?.getBeneficiaryList { (beneficiaryList) in
            guard let list = beneficiaryList else { return }
            
            self.beneficiaries.removeAll()
            self.beneficiaryDropDown.dataSource.removeAll()
            
            for beneficiary in list {
                self.beneficiaries.append(beneficiary)
                self.beneficiaryDropDown.dataSource.append(beneficiary._fullName)
            }
            group.leave()
        }
        
        self.beneficiaryDropDown.selectionAction = { [weak self] (index, item) in
            self?.selectBeneficiary(index, name: item)
        }
    }
    
    private func selectBeneficiary(_ index: Int, name: String) {
        self.beneficiaryDropDown.selectRow(index)
        self.beneficiaryNameLabel.text = name
        self.beneficiarySelectedIndex = index
        self.showHideBeneficiaryError(action: .hide)
    }
    
    private func showHideRequestTo(_ type: RequestBy) {
        
        self.showHideEmailRequest(type)
        self.showHideMobileRequest(type)
        self.showHideQPANRequest(type)
        self.showHideQRCodeRequest(type)
        self.showHideBeneficiaryRequest(type)
        
        switch type {
        case .Mobile:
            break
        case .Email:
            break
        case .QPAN:
            break
        case .QRCode:
            break
        case .Beneficiary:
            break
        }
    }
    
    // MARK: - Views Animation
    
    private func showHideMobileRequest(_ type: RequestBy) {
        self.requestBySelected = type
        
        let condition = type == .Mobile
        self.mobileArrowImageView.image = condition ? downArrow : rightArrow
        self.mobileViewsStackView.isHidden = !condition
        self.animate(for: self.mobileNumberRequestView, condition)
    }
    
    private func showHideEmailRequest(_ type: RequestBy) {
        self.requestBySelected = type
        
        let condition = type == .Email
        self.emailArrowImageView.image = condition ? downArrow : rightArrow
        self.animate(for: self.emailRequestView, condition)
    }
    
    private func showHideQPANRequest(_ type: RequestBy) {
        self.requestBySelected = type
        
        let condition = type == .QPAN
        self.qpanArrowImageView.image = condition ? downArrow : rightArrow
        self.animate(for: self.qpanRequestView, condition)
    }
    
    private func showHideQRCodeRequest(_ type: RequestBy) {
        self.requestBySelected = type
        
        let condition = type == .QRCode
        self.qrCodeArrowImageView.image = condition ? downArrow : rightArrow
        self.animate(for: self.qrCodeRequestView, condition)
    }
    
    private func showHideBeneficiaryRequest(_ type: RequestBy) {
        self.requestBySelected = type
        
        let condition = type == .Beneficiary
        self.beneficiaryArrowImageView.image = condition ? downArrow : rightArrow
        self.animate(for: self.beneficiaryRequestView, condition)
    }
    
    private func animate(for view: UIView,_ isShow: Bool) {
        
        if isShow {
            UIView.animate(withDuration: 0.3) {
                if view.isHidden == true {
                    view.alpha = 1
                    view.isHidden = false
                }
            }
            
        }else {
            UIView.animate(withDuration: 0.3) {
                if view.isHidden == false {
                    view.alpha = 0
                    view.isHidden = true
                }
            }
        }
    }
}
