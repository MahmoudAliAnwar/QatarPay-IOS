//
//  PaymentPopup.swift
//  QPay
//
//  Created by Mahmoud on 04/03/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class PaymentPopup:  ViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var errorImage  : UIImageView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!{
        didSet{
            subTitleLabel.text = "Amount QAR \(remingAmount?.description ?? "")+ Service Charge QAR \(serviceAmount?.description ?? "") + Bank Charge QAR \(bankAmount?.description ?? "")"
        }
    }
    
    var closure: (()->())?
    var message: String?
    var remingAmount: Double?
    var bankAmount: Double?
    var serviceAmount: Double?
    var tryAgainTitle: String? = "Accept"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let amount = remingAmount, let serviceCharge = serviceAmount , let bankCharge = bankAmount else{ return}
         let totalAmount = ((amount ) + (serviceCharge) + (bankCharge))
//        self.totalAmountLabel.text = self.totalAmount?.formatNumber()
        let attrs1 = [NSAttributedString.Key.font : UIFont.sfDisplay(15)?.bold, NSAttributedString.Key.foregroundColor : UIColor.black]

        let attrs2 = [NSAttributedString.Key.font : UIFont.sfDisplay(15)?.regular, NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs3 = [NSAttributedString.Key.font : UIFont.sfDisplay(15)?.bold, NSAttributedString.Key.foregroundColor : UIColor.black]

        let attributedString1 = NSMutableAttributedString(string:"Press Accept ", attributes:attrs1 as [NSAttributedString.Key : Any])

        let attributedString2 = NSMutableAttributedString(string:"to top up wallet with remain of", attributes:attrs2 as [NSAttributedString.Key : Any])
        let attributedString3 = NSMutableAttributedString(string:" QAR \(totalAmount.formatNumber())", attributes:attrs3 as [NSAttributedString.Key : Any])
           


        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
            self.messageLabel.attributedText = attributedString1
      
        self.tryAgainButton.setTitle(tryAgainTitle, for: .normal)
        
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tryAgainAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.closure?()
        }
    }
}

