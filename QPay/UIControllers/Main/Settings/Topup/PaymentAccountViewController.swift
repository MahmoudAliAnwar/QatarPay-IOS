//
//  PaymentAccountViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PaymentAccountViewController: MainController {
    
    @IBOutlet weak var requestsTable: UITableView!
    
    private var accounts = [PaymentAccount]()

    struct PaymentAccount {
        let type: PaymentAccountType
        let completion: voidCompletion
    }
    
    enum PaymentAccountType: Int, CaseIterable {
        case Naps = 0
        case CreditCard
        case Ooredoo
        case OoredooMoney
        case Vodafone
        case PayPal
        
        var title: String {
            get {
                switch self {
                case .CreditCard: return "CreditCard"
                case .Naps: return "NAPS"
                case .Ooredoo: return "Ooredoo"
                case .OoredooMoney: return "Ooredoo Money"
                case .PayPal: return "PayPal"
                case .Vodafone: return "Vodafone"
                }
            }
        }
        
        var image: UIImage {
            switch self {
            case .Naps:
                return .ic_naps_checkout
            case .CreditCard:
                return .ic_credit_card_payment_method
            case .Ooredoo:
                return .ic_ooredoo_payment_method
            case .OoredooMoney:
                return .ic_ooredoo_money_payment_method
            case .Vodafone:
                return .ic_vodafone_checkout
            case .PayPal:
                return .ic_paypal_payment_method
            }
        }
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

extension PaymentAccountViewController {
    
    func setupView() {
        self.requestsTable.delegate = self
        self.requestsTable.dataSource = self
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        self.accounts = PaymentAccountType.allCases.compactMap({ type in
            return PaymentAccount(type: type) {
                switch type {
                case .Naps:
                    let vc = self.getStoryboardView(DebitCardAccountViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .CreditCard:
                    let vc = self.getStoryboardView(CreditCardAccountViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .Ooredoo:
                    let vc = self.getStoryboardView(OoredooAccountViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .OoredooMoney:
                    self.showAlertMessage(message: "Coming soon")
                case .Vodafone:
                    let vc = self.getStoryboardView(VodafoneAccountViewController.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .PayPal:
                    self.showAlertMessage(message: "Coming soon")
                }
            }
        })
    }
}

// MARK: - ACTIONS

extension PaymentAccountViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW DELEGATE

extension PaymentAccountViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(PaymentAccountTableViewCell.self, for: indexPath)
        
        let account = self.accounts[indexPath.row]
        cell.paymentAccount = account
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paymentAccount = self.accounts[indexPath.row]
        paymentAccount.completion()
    }
}

// MARK: - REQUESTS DELEGATE

extension PaymentAccountViewController: RequestsDelegate {
    
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

// MARK: - PRIVATE FUNCTIONS

extension PaymentAccountViewController {
    
}
