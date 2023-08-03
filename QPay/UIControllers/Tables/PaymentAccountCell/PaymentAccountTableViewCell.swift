//
//  PaymentAccountTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/23/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class PaymentAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentTitle: UILabel!
    
    var paymentAccount: PaymentAccountViewController.PaymentAccount! {
        willSet {
            self.paymentImageView.image = newValue.type.image
            self.paymentTitle.text = newValue.type.title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
