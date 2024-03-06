//
//  PaymentRequestCodeViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/20/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmPinCodeViewController: ViewController {
    
    @IBOutlet weak var code1TextField: UITextField!
    
    @IBOutlet weak var code2TextField: UITextField!
    
    @IBOutlet weak var code3TextField: UITextField!
    
    @IBOutlet weak var code4TextField: UITextField!
    
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var updateViewElementDelegate: UpdateViewElement?
    var handler: ((String) -> Void)?
    
    var paymentViaBillResponse: PaymentRequestViaBillResponse?
    var notification: NotificationModel?
    var transfer: Transfer?
    var validateObject: ValidateMerchantQRCode?
    var data: Any?
    var dataArray: [Any]?
    var succesClosure: (()->())?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
        
        self.code1TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code2TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code3TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        self.code4TextField.addTarget(self, action: #selector(self.textFieldDidBegin(_:)), for: .editingDidBegin)
        
        self.code1TextField.addTarget(self, action: #selector(self.textField1DidChange(_:)), for: .editingChanged)
        self.code2TextField.addTarget(self, action: #selector(self.textField2DidChange(_:)), for: .editingChanged)
        self.code3TextField.addTarget(self, action: #selector(self.textField3DidChange(_:)), for: .editingChanged)
        self.code4TextField.addTarget(self, action: #selector(self.textField4DidChange(_:)), for: .editingChanged)
    }
}

// MARK: - ACTIONS

extension ConfirmPinCodeViewController {
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.closeView(false)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension ConfirmPinCodeViewController {

    @objc func textFieldDidBegin(_ textField : UITextField) {
        textField.text?.removeAll()
    }
    
    @objc func textField1DidChange(_ textField : UITextField) {
        
        guard textField == self.code1TextField else { return }
        guard let code1 = self.code1TextField.text, code1.isNotEmpty else {
            return
        }
        
        if code1.count == 1 {
            self.code2TextField.becomeFirstResponder()
        }
    }
    
    @objc func textField2DidChange(_ textField : UITextField) {
        
        guard textField == self.code2TextField else { return }
        guard let code2 = self.code2TextField.text, code2.isNotEmpty else {
            return
        }
        if code2.count == 1 {
            self.code3TextField.becomeFirstResponder()
        }
    }
    
    @objc func textField3DidChange(_ textField : UITextField) {
        
        guard textField == self.code3TextField else { return }
        guard let code3 = self.code3TextField.text, code3.isNotEmpty else {
            return
        }
        if code3.count == 1 {
            self.code4TextField.becomeFirstResponder()
        }
    }
    
    @objc func textField4DidChange(_ textField : UITextField) {
        
        guard let code4 = self.code4TextField.text,
              code4.isNotEmpty,
              code4.count == 1 else {
            return
        }
        
        self.view.endEditing(true)
        
        guard let presentingView = self.presentingViewController?.children.last else { return }
        
        guard let cd1 = self.code1TextField.text, cd1.isNotEmpty,
              let cd2 = self.code2TextField.text, cd2.isNotEmpty,
              let cd3 = self.code3TextField.text, cd3.isNotEmpty else {
            return
        }
        
        let pinCode = "\(cd1)\(cd2)\(cd3)\(code4)"
        
        /// Library VIEW...
        
        if presentingView is MyLibraryViewController {
            self.sendVerifyPin(pinCode) {
                self.closeView(true)
            }
            
        /// Notification VIEW...
            
        }else if presentingView is NotificationsViewController {
            guard let notif = self.notification,
                  let refID = notif.referenceID else {
                return
            }
            self.sendPayRequest(pinCode, for: refID)
            
        /// Home VIEW...
            
        }else if presentingView is HomeViewController {
            guard let data = self.dataArray,
                  let scenarioNumber = data.first as? Character else {
                return
            }
            if scenarioNumber == "1" {
                guard let object = data[1] as? ValidateMerchantQRCode else { return }
                self.sendTransferQRCodePayment(pinCode, validateObject: object)
                
            }else if scenarioNumber == "2" {
                guard let object = data[1] as? Transfer else { return }
                self.sendPayToMerchant(pinCode, transfer: object)
            
            } else if scenarioNumber == "3" {
                guard let object = data[1] as? ValidateMerchantQRCode else { return }
                self.sendTransferQRCodeWithAmount(pinCode, validateObject: object)
            }
            
        /// Gift Card Purchase VIEW...
            
        } else if presentingView is GiftCardPurchaseViewController {
            guard let giftTransfer = self.data as? GiftTransfer else { return }
            self.sendBuyGiftDenomination(pinCode, giftTransfer: giftTransfer)
            
        /// International Topup VIEW...
            
        } else if presentingView is InternationalTopupViewController {
            guard let transfer = self.data as? Transfer else { return }
            
            self.sendConfirmEstoreTopup(pinCode, transfer: transfer)
            
        /// Refill Karwa Bus Card VIEW...
            
        } else if presentingView is RefillKarwaBusCardViewController {
            guard let transfer = self.data as? KarwaBusTransfer else { return }
            
            self.sendConfirmKarwaBusTopup(pinCode, transfer: transfer)
            
        } else if presentingView is PhoneOoredooViewController         ||
                    presentingView is PhoneVodafoneViewController        ||
                    presentingView is PhoneBillOperationsViewController  ||
                    presentingView is KahramaaBillsViewController        ||
                    presentingView is KahrmaBillOperationsViewController ||
                    presentingView is QatarCoolViewController            ||
                    presentingView is QatarCoolOperationsViewController  ||
                    presentingView is PaymentVC{
            
            guard let response = self.paymentViaBillResponse else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            self.sendNoqsTransferPayment(pinCode,
                                         accessToken: response._accessToken,
                                         verificationID: response._verificationID,
                                         requestID: response._requestID, billID: [])
        } else {
//            self.sendVerifyPin(pinCode) {
                self.dismiss(animated: true) {
                    self.handler?(pinCode)
                }
//            }
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmPinCodeViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .confirmPaymentRequests ||
            request == .verifyPin ||
            request == .payToMerchant ||
            request == .transferQRCodePayment ||
            request == .buyGiftDenomination ||
            request == .confirmEstoreTopup ||
            request == .confirmKarwaBusTopup ||
            request == .payParkingViaNoqs ||
            request == .noqsTransferBillPayment {
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
                    if showUserExceptions,
                       request != .noqsTransferBillPayment {
                        self.showErrorMessage(exc)
                    }
                    break
                case .AlamofireError(_):
                    if showAlamofireErrors {
                        self.showErrorMessage()
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

extension ConfirmPinCodeViewController {
    
    private func sendTransferQRCodeWithAmount(_ pinCode: String, validateObject: ValidateMerchantQRCode) {
        
        guard let qrData = validateObject.qrCodeData else { return }
        
        self.requestProxy.requestService()?.transferQRCodeWithAmount(pinCode: pinCode, qrData: qrData, completion: { status, response in
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "Transfer Confirmed Successfully")
            }
        })
    }
    
    private func sendConfirmKarwaBusTopup(_ code: String, transfer: KarwaBusTransfer) {
        self.requestProxy.requestService()?.confirmKarwaBusTopup(transfer: transfer, pinCode: code) { (status, baseResponse) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: baseResponse?.message ?? "")
            }
        }
    }
    
    private func sendConfirmEstoreTopup(_ code: String, transfer: Transfer) {
        self.requestProxy.requestService()?.confirmEstoreTopup(transfer, pinCode: code, completion: { (status, baseResponse) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: baseResponse?.message ?? "")
            }
        })
    }
    
    private func sendBuyGiftDenomination(_ code: String, giftTransfer: GiftTransfer) {
        self.requestProxy.requestService()?.buyGiftDenomination(giftTransfer: giftTransfer, pinCode: code, completion: { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "")
            }
        })
    }
    
    private func sendTransferQRCodePayment(_ code: String, validateObject: ValidateMerchantQRCode) {
        guard let sessionID = validateObject.sessionID,
              let uuid = validateObject.UUID,
              let qrData = validateObject.qrCodeData else {
            return
        }
        self.requestProxy.requestService()?.transferQRCodePayment(pinCode: code, qrData: qrData, sessionID: sessionID, uuid: uuid) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "Transfer Confirmed Successfully")
            }
        }
    }
    
    private func sendPayToMerchant(_ code: String, transfer: Transfer) {
        self.requestProxy.requestService()?.payToMerchant(transfer, pinCode: code) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                self.closeView(true, data: response?.message ?? "Pay Confirmed Successfully")
            }
        }
    }
    
    private func sendVerifyPin(_ pin: String, completion: @escaping voidCompletion) {
        self.requestProxy.requestService()?.verifyPin(pin: pin) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                completion()
//                self.closeView(true)
            }
        }
    }
    
    private func sendPayRequest(_ code: String, for refID: Int) {
        self.requestProxy.requestService()?.confirmPaymentRequests(id: refID, pinCode: code) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard let presentingView = self.presentingViewController?.children.last as? NotificationsViewController else {
                    return
                }
                self.closeView(true)
                presentingView.showSuccessMessage(response?.message ?? "Pay Confirmed Successfully")
            }
        }
    }
    
    private func sendNoqsTransferPayment(_ code: String,
                                         accessToken    : String,
                                         verificationID : String,
                                         requestID      : [String],
                                         billID         : [Int]?) {
        
        self.codeErrorLabel.isHidden = true
        self.requestProxy.requestService()?.noqsTransferBillPayment(accessToken: accessToken,
                                                                    verificationID: verificationID,
                                                                    requestID: requestID,
                                                                    pinCode: code, 
                                                                    billID: billID)
                                                                    { response in
            guard let resp = response else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            guard resp._success else {
                self.codeErrorLabel.isHidden = false
                self.codeErrorLabel.text = resp._message
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard let presentingView = self.presentingViewController?.children.last as? ViewController else {
                    return
                }
                self.closeView(true)
                presentingView.showSuccessMessage(resp._message) {
                    self.succesClosure?()
                }
            }
        }
    }
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
        self.dismiss(animated: true)
    }
    
    private func showHideCodeError(status: Bool) {
        if status {
            if !self.codeErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeErrorLabel.isHidden = true
                }
            }
        }else {
            if self.codeErrorLabel.isHidden {
                UIView.animate(withDuration: 0.3) {
                    self.codeErrorLabel.isHidden = false
                }
            }
        }
    }
}
