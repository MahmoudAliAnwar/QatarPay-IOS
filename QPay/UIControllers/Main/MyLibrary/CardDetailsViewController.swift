//
//  CardDetailsViewController.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CardDetailsViewController: MainController {
    
    @IBOutlet weak var cardTypeImageView: UIImageView!
    
    @IBOutlet weak var trashView: UIView!
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    /// Card Outlets ...
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardCodeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    /// Bank Outlets ...
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountCountryLabel: UILabel!
    @IBOutlet weak var swiftCodeLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    
    @IBOutlet weak var bankStackView: UIStackView!
    @IBOutlet weak var cardStackView: UIStackView!
    
    var card: LibraryCard?
    var bank: Bank?
    
    var updateElementDelegate: UpdateViewElement?
    
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

extension CardDetailsViewController {
    
    func setupView() {
        self.cardImageViewDesign.cornerRadius = (self.cardImageViewDesign.height/10)
    }
    
    func localized() {
    }
    
    func setupData() {
        self.isBankShow(self.card == nil)
        
        if let myCard = card {

            if var number = myCard.number, number.isNotEmpty {
                number.insert(separator: "  ", every: 4)
                self.cardCodeLabel.text = number
            }
            
            self.dateLabel.text = myCard._expiryDate
            self.cvvLabel.text = myCard._cvv
            self.nameLabel.text = myCard._ownerName
            
//            var paymentType = ""
            if let paymentCardType = myCard.paymentCardType,
               let payment = PaymentCardType(rawValue: paymentCardType) {
                switch payment {
                case .Credit:
                    self.viewTitleLabel.text = "Credit Card"
//                    paymentType = "Credit"
                case .Debit:
                    self.viewTitleLabel.text = "Debit Card"
//                    paymentType = "Debit"
                }
            }
            
            if let reminderString = card?.reminderType, reminderString.isNotEmpty,
               let reminder = ExpiryReminder.getObjectByNumber(reminderString) {
                self.reminderLabel.text = reminder.rawValue
            }
            
            if let type = myCard.cardType, type.isNotEmpty,
               let cardType = CardType(rawValue: type) {
                self.cardTypeLabel.text = "\(cardType.rawValue)".uppercased()
                
                switch cardType {
                case .Visa:
                    self.cardTypeImageView.image = .ic_visa_card_details
                case .Master:
                    self.cardTypeImageView.image = .ic_mastercard_card_details
                case .American, .Diners, .JCB, .Maestro:
                    self.cardTypeImageView.image = .ic_unknown_card_details
                }
            }
            
            if let frontUrl = myCard.frontImagePath {
                frontUrl.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.cardImageViewDesign.image = image
                }
            }
            
        } else if let bnk = self.bank {
            self.viewTitleLabel.text = "Bank Account Details"
            
            self.cardTypeImageView.image = .ic_unknown_card_details
            
            self.accountNameLabel.text = bnk.accountName ?? ""
            self.accountCountryLabel.text = bnk.countryName ?? ""
            self.bankNameLabel.text = bnk.name ?? ""
            self.swiftCodeLabel.text = bnk.swiftCode ?? ""
            self.ibanLabel.text = bnk.iban ?? ""
            
            self.accountNumberLabel.text = bnk.accountNumber ?? ""
        }
    }
    
    func fetchData() {
    }
}

// MARK: - ACTIONS

extension CardDetailsViewController {
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteCardAction(_ sender: UIButton) {
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

// MARK: - REQUESTS DELEGATE

extension CardDetailsViewController: RequestsDelegate {
    
    func requestStarted(request: RequestType) {
        if request == .deleteBank {
            showLoadingView(self)
        }
    }
    
    func requestFinished(request: RequestType, result: ResponseResult) {
        hideLoadingView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + loadingViewDismissDelay) {
            switch result {
            case .Success(_):
                self.navigationController?.popViewController(animated: true)
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

extension CardDetailsViewController {
    
    private func isBankShow(_ status: Bool) {
        self.bankStackView.isHidden = !status
        self.cardStackView.isHidden = status
        self.cardImageViewDesign.isHidden = status
        self.trashView.isHidden = !status
    }
}
