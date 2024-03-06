//
//  TopupTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 19/11/2020.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class TopupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var accountDefaultLabel: UILabel!

    var topup: Topup? {
        didSet {
            self.accountNameLabel.text = topup?.cardName ?? ""
            self.accountTypeLabel.text = topup?.cardType ?? ""
            self.accountDefaultLabel.text = (topup?.isDefault == true) ? "Default" : "Secondary"
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
