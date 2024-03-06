//
//  PaymentRequestCodeViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/20/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ConfirmQRCodePayViewController: ViewController {
    
    @IBOutlet weak var shopLogoImageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var qpanNumberLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var parentView: UIViewController?
    var updateViewElementDelegate: UpdateViewElement?
    
    var validateObject: ValidateMerchantQRCode!
    var scenarioNumber: Character!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.shopNameLabel.text = self.validateObject.merchantName ?? ""
        self.qpanNumberLabel.text = self.validateObject.merchantCompanyName ?? ""
 
        if let logo = self.validateObject.merchantLogo {
            logo.getImageFromURLString { (status, image) in
                if status, let img = image {
                    self.shopLogoImageView.image = img
                }
            }
        }
        
        if self.scenarioNumber == "1" || self.scenarioNumber == "3" {
            self.amountTextField.text = self.validateObject._amount.formatNumber()
            self.amountTextField.isEnabled = false
            
        }else {
            self.amountTextField.isEnabled = true
        }
        
        if let qpan = self.validateObject.merchantReference {
            self.qpanNumberLabel.text = "QPAN \(self.encryptQPAN(qpan))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarView?.isHidden = true
        
        self.requestProxy.requestService()?.delegate = self
    }
}

// MARK: - ACTIONS

extension ConfirmQRCodePayViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.closeView(false)
    }
    
    @IBAction func payAction(_ sender: UIButton) {
        
        if self.scenarioNumber == "1" ||
            self.scenarioNumber == "3" {
            
            self.closeView(true, data: [self.scenarioNumber!, self.validateObject!])
            
        }else if self.scenarioNumber == "2" {
            
            guard let amountString = self.amountTextField.text, amountString.isNotEmpty else {
                self.showErrorMessage("Enter the amount")
                return
            }
            
            guard let qrCodeData = self.validateObject.qrCodeData,
                  let amount = Double(amountString.convertedDigitsToLocale()) else {
                      return
                  }
            
            self.requestProxy.requestService()?.payFromQRCode(amount: amount, QRCode: qrCodeData, completion: { (status, transfer) in
                guard status else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                    guard let trans = transfer else { return }
                    self.closeView(true, data: [self.scenarioNumber!, trans])
                }
            })
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmQRCodePayViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .payFromQRCode {
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

extension ConfirmQRCodePayViewController {
    
    private func closeView(_ status: Bool, data: Any? = nil) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementUpdated(fromSourceView: self, status: status, data: data)
    }
    
    private func closeView(_ status: Bool, data: [Any]? = nil) {
        self.dismiss(animated: true)
        self.updateViewElementDelegate?.elementsUpdated?(fromSourceView: self, status: status, data: data)
    }
    
    private func sendPayToMerchant(_ code: String, transfer: Transfer) {
        self.requestProxy.requestService()?.payToMerchant(transfer, pinCode: code) { (status, response) in
            guard status else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
                guard let presentingView = self.presentingViewController?.children.last as? HomeViewController else {
                    return
                }
                self.closeView(true)
                presentingView.showSuccessMessage(response?.message ?? "Pay Confirmed Successfully")
            }
        }
    }
    
    private func encryptQPAN(_ qpan: String) -> String {
        let last = qpan.suffix(4)
        return "**** **** **** \(last)"
    }
}
