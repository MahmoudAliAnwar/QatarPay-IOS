//
//  InvoiceTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0))

//        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
        
//        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
//        bounds = bounds.inset(by: padding)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setupData(invoice: Invoice) {
        
        if let reference = invoice.reference {
            self.numberLabel.text = reference
        }
        
        if let customer = invoice.customerName {
            self.customerLabel.text = customer
        }
        
        if let total = invoice.totalAmount {
            self.ammountLabel.text = "QAR \(total.description)"
        }
    }
}
