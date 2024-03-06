//
//  TokenizedPaymentCell.swift
//  QPay
//
//  Created by Mahmoud on 02/02/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class TokenizedPaymentCell: UITableViewCell {

    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var holderView: UIView!{
        didSet{
            
            holderView.layer.cornerRadius = 5
            holderView.clipsToBounds = true
        }
    }
    
    func config(cardSaved: TokenizedCard?){
        self.cardNumber.text = cardSaved?._cardNumber
    }
}
