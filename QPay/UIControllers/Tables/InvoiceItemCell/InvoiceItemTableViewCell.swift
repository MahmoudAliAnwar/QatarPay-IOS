//
//  InvoiceItemTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/9/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemIDLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemQuantityLabel: UILabel!
    @IBOutlet weak var itemAmountLabel: UILabel!
    
    var cellIndex: IndexPath! {
        didSet {
            self.itemIDLabel.text = (cellIndex.row + 1).description
        }
    }
    
    var orderItem: OrderDetails! {
        didSet {
            self.itemNameLabel.text = orderItem.productName ?? ""
            self.itemDescriptionLabel.text = "\(orderItem.productDescription ?? "")"
            self.itemQuantityLabel.text = Int(orderItem.quantity ?? 0.0).description
            self.itemAmountLabel.text = "QAR \((orderItem.total ?? 0.0).description)"
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
