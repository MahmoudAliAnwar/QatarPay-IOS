//
//  PaymentCell.swift
//  QPay
//
//  Created by Mahmoud on 31/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var paymentImageView: UIImageView!
    
    func confige(image: String){
        guard image.isNotEmpty else { return }
        self.paymentImageView.kf.setImage(with: URL(string:image), placeholder: UIImage.ic_credit_card_payment_method)
        
    }
}
