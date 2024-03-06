//
//  OtherCell.swift
//  QPay
//
//  Created by Mahmoud on 20/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class OtherCell: UICollectionViewCell {
    
    static let identifier = String(describing: OtherCell.self)
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var cardCodeLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    @IBOutlet weak var cardUserNameLabel: UILabel!
    @IBOutlet weak var cardTypeImageView: UIImageView!
   
    func configer(card: TokenizedCard?){
        self.cardCodeLabel.text = card?._cardNumber
        self.cardExpiryLabel.text = card?.expiryDate
        self.cardUserNameLabel.text = card?.cardName?.uppercased()
        
        if let type = card?.cardType, type.isNotEmpty,
           let cardType = CardType(rawValue: type) {
          
            
            switch cardType {
            case .Visa:
                self.cardTypeImageView.image = .ic_visa_logo_card
            case .Master:
                self.cardTypeImageView.image = UIImage(named: "ic_mastercard_logo_card2")
            case .American, .Diners, .JCB, .Maestro:
                self.cardTypeImageView.image = .ic_unknown_card_details
            }
        }
    
        
    }

}
