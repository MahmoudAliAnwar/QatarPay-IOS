//
//  ConfirmRefillWalletViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/07/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import SafariServices

class ConfirmRefillWalletViewController: MainController {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    
    var channel: Channel?
    var amount: Double?
    var object: BaseResponse?
    
    var response: PaymentRequestViaBillResponse?
    var fromPaymentVC: Bool?
   
    var totalAmount: Double?
    var payWithWallet: Bool?
    var isTokenized: Bool?
   
    weak var delgate: PaymentProtocol?
    
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
        
    }
}

extension ConfirmRefillWalletViewController {
    
    func setupView() {
        self.requestProxy.requestService()?.delegate = self
        
        self.containerViewDesign.setViewCorners([.topLeft, .topRight])
        
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        if fromPaymentVC  ?? false{
            guard let amount =  payWithWallet ?? false ? response?.RemainingAmount: object?._baseAmount , let serviceCharge = payWithWallet ?? false ? response?.ServiceCharge: object?._serviceCharge , let bankCharge = payWithWallet ?? false ? response?.BankingCharge : 0.0 else{ return}
            self.totalAmount = ((amount ) + (serviceCharge) + (bankCharge))
            self.totalAmountLabel.text = self.totalAmount?.formatNumber()
            self.serviceChargeLabel.text = "\(amount) QAR + \(bankCharge.formatNumber()) QAR Bank Charge+ \(serviceCharge.formatNumber()) QAR Service Charge"
            
            self.titleLabel.text = payWithWallet ?? true ?  "Top-up Wallet": "Review charges"
            self.firstLabel.text = payWithWallet ?? true ? "Review Top-up details.": " Review charges details."
            
        }else{
            guard let resp = self.object else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            //        let service = resp.serviceCharge ?? 0.0
            self.setServiceChargeLabel(resp._baseAmount, charge: resp._serviceCharge)
            self.totalAmountLabel.text = (resp._baseAmount + resp._serviceCharge).formatNumber()
        }
    }
}

// MARK: - ACTIONS

extension ConfirmRefillWalletViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
        if fromPaymentVC ?? false {
            self.navigationController?.popViewController(animated: true)
            self.delgate?.didTapConfirm(response: self.response, payWithWallet:  self.payWithWallet, baseResponse: self.object, isTokenized: self.isTokenized ?? false)
           
            
        }else {
            
            guard let refill = self.object else {
                self.showSnackMessage("Something went wrong")
                return
            }
            
            var url: URL?
            
            //        if let urlString = refill.validationURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            //            url = URL(string: urlString)
            //        }
            
            if let urlString = refill.paymentLink?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url = URL(string: urlString)
            }
            
            guard let url = url else {
                self.showSnackMessage("Missing URL")
                return
            }
            self.openWebView(with: url)
        }
    }
}

// MARK: - REQUESTS DELEGATE

extension ConfirmRefillWalletViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .getRefillCharge {
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

extension ConfirmRefillWalletViewController {
    
    private func setServiceChargeLabel(_ amount: Double, charge: Double) {
        self.serviceChargeLabel.text = "\(amount.formatNumber()) QAR + \(charge.formatNumber()) QAR Service Charge"
    }
    
    private func openWebView(with url: URL?) {
        let vc = self.getStoryboardView(WebViewController.self)
        vc.webPageUrl = url
        vc.parentView = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
