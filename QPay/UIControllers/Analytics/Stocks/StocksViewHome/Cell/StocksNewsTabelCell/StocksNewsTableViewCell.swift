//
//  StocksNewsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class StocksNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel  : UILabel!
    
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var bodyLabel  : UILabel!
    
    var object : StocksNews! {
        willSet {
            self.titleLabel.text = newValue._stockNewsTitle
            self.bodyLabel.text  = newValue._stockNewsDescription
            self.bodyLabel.sizeToFit()
            
            guard let date  = newValue._stockNewsDate.convertFormatStringToDate(ServerDateFormat.Server2.rawValue) else {
                return
            }
            self.dateLabel.text = "\(date.formatDate("MMM d, yyyy"))"
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
