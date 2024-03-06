//
//  ParkingPaymentTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 27/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class ParkingPaymentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentNameLabel: UILabel!
    @IBOutlet weak var paymentAmountLabel: UILabel!
    
    @IBOutlet weak var paymentCodeStackView: UIStackView!
    @IBOutlet weak var paymentCodeLabel: UILabel!
    
    var object: ParkingsPaymentViewController.ParkingPayment! {
        didSet {
            self.paymentImageView.image = object.icon
            self.paymentNameLabel.text = object.name
            self.paymentAmountLabel.text = "\(object.amount.formatNumber()) QAR"
            
            self.paymentCodeStackView.isHidden = object.code == nil
            if let cd = object.code {
                self.paymentCodeLabel.text = cd
            }
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
