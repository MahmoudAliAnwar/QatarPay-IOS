//
//  PayOnTheGoQatarCoolViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PayOnTheGoQatarCoolViewController: QatarCoolController {
    
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var creditCheckBox: CheckBox!
    
    @IBOutlet weak var debitView: UIView!
    @IBOutlet weak var debitCheckBox: CheckBox!
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletCheckBox: CheckBox!
    
    @IBOutlet weak var qidNumberTextField: UITextField!
    @IBOutlet weak var qidNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var serviceNumberTextField: UITextField!
    @IBOutlet weak var serviceNumberErrorImageView: UIImageView!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberErrorImageView: UIImageView!
    
    var amount: Double = 0.0
    
    private var color: UIColor = .mVery_Dark_Blue
    
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

extension PayOnTheGoQatarCoolViewController {
    
    func setupView() {
        self.setupCheckBoxes()
        self.setToggleBtn(.credit)
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension PayOnTheGoQatarCoolViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func creditAction(_ sender: UIButton) {
        self.setToggleBtn(.credit)
    }
    
    @IBAction func debitAction(_ sender: UIButton) {
        self.setToggleBtn(.debit)
    }
    
    @IBAction func walletAction(_ sender: UIButton) {
        self.setToggleBtn(.wallet)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        
        if self.qidNumberTextField.text!.isEmpty {
            self.showHideQIDError()
            
        } else if self.serviceNumberTextField.text!.isEmpty {
            self.showHideQIDError(action: .hide)
            self.showHideServiceError()
            
        } else if self.mobileNumberTextField.text!.isEmpty {
            self.showHideQIDError(action: .hide)
            self.showHideServiceError(action: .hide)
            self.showHideMobileError()
            
        } else {
            self.showHideMobileError(action: .hide)
            self.showHideQIDError(action: .hide)
            self.showHideServiceError(action: .hide)
            
            guard self.amount > 0 else { return }
            
            guard let qidNumber: String = self.qidNumberTextField.text,
                  qidNumber.isNotEmpty,
                  let serviceNumber: String = self.serviceNumberTextField.text,
                  serviceNumber.isNotEmpty,
                  let mobile: String = self.mobileNumberTextField.text,
                  mobile.isNotEmpty else {
                return
            }
            
            self.sendPaymentRequest(for: .qatar_cool,
                                    paymentMethod: self.selectedCardType,
                                    amount: self.amount,
                                    qidNumber: qidNumber,
                                    serviceNumber: serviceNumber,
                                    mobile: mobile)
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension PayOnTheGoQatarCoolViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .paymentDueToPay {
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

// MARK: - CUSTOM FUNCTIONS

extension PayOnTheGoQatarCoolViewController {
    
    private func setupCheckBoxes() {
        self.creditCheckBox.style = .circle
        self.creditCheckBox.tintColor = .clear
        self.creditCheckBox.borderWidth = 0
        
        self.debitCheckBox.style = .circle
        self.debitCheckBox.tintColor = .clear
        self.debitCheckBox.borderWidth = 0
        
        self.walletCheckBox.style = .circle
        self.walletCheckBox.tintColor = .clear
        self.walletCheckBox.borderWidth = 0
    }
    
    private func setToggleBtn(_ type: DueToPaySectionController.BillCardTypes) {
        self.selectedCardType = type
        self.creditToggleStatus(type)
        self.debitToggleStatus(type)
        self.walletToggleStatus(type)
    }
    
    private func creditToggleStatus(_ type: DueToPaySectionController.BillCardTypes) {
        self.creditView.backgroundColor = type == .credit ? self.color : .lightGray
        self.creditCheckBox.isChecked = type == .credit
    }
    
    private func debitToggleStatus(_ type: DueToPaySectionController.BillCardTypes) {
        self.debitView.backgroundColor = type == .debit ? self.color : .lightGray
        self.debitCheckBox.isChecked = type == .debit
    }
    
    private func walletToggleStatus(_ type: DueToPaySectionController.BillCardTypes) {
        self.walletView.backgroundColor = type == .wallet ? self.color : .lightGray
        self.walletCheckBox.isChecked = type == .wallet
    }
    
    private func showHideQIDError(action: ViewErrorsAction = .show) {
        self.qidNumberErrorImageView.image = action == .show ? #imageLiteral(resourceName: "ic_error_circle") : .none
    }
    
    private func showHideServiceError(action: ViewErrorsAction = .show) {
        self.serviceNumberErrorImageView.image = action == .show ? #imageLiteral(resourceName: "ic_error_circle") : .none
    }
    
    private func showHideMobileError(action: ViewErrorsAction = .show) {
        self.mobileNumberErrorImageView.image = action == .show ? #imageLiteral(resourceName: "ic_error_circle") : .none
    }
}
