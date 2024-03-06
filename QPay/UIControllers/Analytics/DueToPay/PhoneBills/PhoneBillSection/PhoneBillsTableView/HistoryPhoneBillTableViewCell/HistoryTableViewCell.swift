//
//  HistoryTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 03/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var billAmountLabel : UILabel!

    @IBOutlet weak var paidAmountLabel : UILabel!

    @IBOutlet weak var dateLabel       : UILabel!

    @IBOutlet weak var statusLabel     : UILabel!

    @IBOutlet weak var billNumberLabel : UILabel!
    
    var object : PreviousBill? {
        willSet {
            guard let data = newValue else { return }
            self.billAmountLabel.text = ": \(data._bill)"
            self.paidAmountLabel.text = ": \(data._amounttobePaid)"
            self.statusLabel.text     = ": \(data._status)"
            self.billNumberLabel.text = ": \(data._billNumber)"
            
            guard let date  = data._date.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) else {
                return
            }
            self.dateLabel.text       = ": \(date.formatDate("dd/MM/yyyy"))"
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
