//
//  CardCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardTypeWidth: NSLayoutConstraint!
    @IBOutlet weak var cardCodeLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
//    func setupData(card: Card) {
//
//        if let accountNumber = card.accountNumber, accountNumber.isNotEmpty {
//
//            self.cardCodeLabel.text = getCode(code: accountNumber)
//
//            self.cardImageView.image = UIImage.init(named: "ic_unknown_card") ?? UIImage.init()
//            self.cardTypeImageView.image = UIImage.init(named: "ic_bank") ?? UIImage.init()
//            self.cardTypeWidth.constant = 40
//            self.cardTypeLabel.text = "Bank Account"
//
//        }else {
//            let typeName = card.type ?? ""
//            let cardType = CardType.init(rawValue: typeName)
//
//            if let number = card.number {
//                self.cardCodeLabel.text = getCode(code: number)
//            }
//
//            if let type = cardType {
//
//                var paymentType = ""
//                if let paymentCardType = card.paymentCardType {
//                    let payment = PaymentCardType.init(rawValue: paymentCardType)
//                    switch payment! {
//                    case .Credit:
//                        paymentType = "Credit"
//                    case .Debit:
//                        paymentType = "Debit"
//                    }
//                }
                
//                switch type {
//                case .MasterCard:
//                    self.cardImageView.image = UIImage.init(named: "ic_mastercard") ?? UIImage.init()
//                    self.cardTypeImageView.image = UIImage.init(named: "ic_mastercard_logo_card") ?? UIImage.init()
//                    self.cardTypeWidth.constant = 40
//                    self.cardTypeLabel.text = "\(cardType!.rawValue) \(paymentType)"
//
//                case .Visa:
//                    self.cardImageView.image = UIImage.init(named: "ic_visacard") ?? UIImage.init()
//                    self.cardTypeImageView.image = UIImage.init(named: "ic_visa_logo_card") ?? UIImage.init()
//                    self.cardTypeWidth.constant = 80
//                    self.cardTypeLabel.text = "\(cardType!.rawValue)Card \(paymentType)"
//
//                case .Maestro:
//                    break
//                case .Unknown:
//                    self.cardImageView.image = UIImage.init(named: "ic_unknown_card") ?? UIImage.init()
//                    self.cardTypeImageView.image = UIImage.init(named: "ic_visa_logo_card") ?? UIImage.init()
//                    self.cardTypeWidth.constant = 80
//                    self.cardTypeLabel.text = "\(type.rawValue) \(paymentType)"
//                }
//            }
//        }
//    }
    
    private func getCode(code: String) -> String {
        
        var str = ""
        
        code.enumerated().makeIterator().forEach { (offset, element) in
            if offset == (code.count - 1) {
                str += element.description
            }else if offset == (code.count - 2) {
                str += element.description
            }else if offset == (code.count - 3) {
                str += element.description
            }else if offset == (code.count - 4) {
                str += element.description
            }
        }
        return str
    }
}
