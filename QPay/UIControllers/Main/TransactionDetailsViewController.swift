//
//  TransactionDetailsViewController.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/09/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol TransactionDetailsViewControllerDelegate: AnyObject {
    func didTapAddBenefeciary(_ view: TransactionDetailsViewController, with transaction: Transaction)
}

class TransactionDetailsViewController: ViewController {
    
    @IBOutlet weak var addBenefeciaryButton: UIButton!
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var userImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var qpanLabel: UILabel!
    
    @IBOutlet weak var userTypeLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var subAmountLabel: UILabel!
    
    @IBOutlet weak var transactionTypeLabel: UILabel!
    
    @IBOutlet weak var referenceNumberLabel: UILabel!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    var transaction: Transaction?
    
    weak var delegate: TransactionDetailsViewControllerDelegate?
    
    private let descPlaceholder = "sample notes here..."
    
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
        
        self.statusBarView?.isHidden = true
        
        guard let trans = self.transaction else { return }
        
        if let imgUrl = trans.destinationImageUrl {
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                self.userImageViewDesign.image = image
            }
        }
        
        if let userType = trans.userType,
           let type = Transaction.UserType(rawValue: userType) {
            self.userTypeLabel.text = "\(type.title)"
        }
        
        self.usernameLabel.text = trans.destinationUserName ?? "Empty"
        self.qpanLabel.text = "QPAN\(trans.QPAN ?? "")"
        
        let amount = (trans.amount ?? 0.00).formatNumber()
        self.amountLabel.text = "\(amount)"
        self.subAmountLabel.text = "= QAR \(amount)"
        
        self.transactionTypeLabel.text = "\(trans.type ?? "")"
        self.referenceNumberLabel.text = "\(trans.referenceNo ?? "")"
        self.emailAddressLabel.text = "\(trans.destinationEmail ?? "")"
        self.mobileNumberLabel.text = "\(trans.mobileNumber ?? "")"
    }
}

extension TransactionDetailsViewController {
    
    func setupView() {
        self.containerViewDesign.cornerRadius = self.containerViewDesign.width / 16
    }
    
    func localized() {
    }
    
    func setupData() {
    }
    
    func fetchData() {
        guard let trans = self.transaction else { return }
        self.addBenefeciaryButton.isHidden = trans._beneficiaryAddType == .Added
    }
}

// MARK: - ACTIONS

extension TransactionDetailsViewController {
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addBenefeciaryAction(_ sender: UIButton) {
        guard let trans = self.transaction else { return }
        self.dismiss(animated: true) {
            self.delegate?.didTapAddBenefeciary(self, with: trans)
        }
    }
}

// MARK: - CUSTOM FUNCTIONS

extension TransactionDetailsViewController {
    
}
