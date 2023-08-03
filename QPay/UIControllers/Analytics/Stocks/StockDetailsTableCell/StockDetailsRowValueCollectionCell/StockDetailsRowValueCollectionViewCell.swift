//
//  StockDetailsRowValueCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class StockDetailsRowValueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    var value: String = "" {
        willSet {
            self.valueLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
