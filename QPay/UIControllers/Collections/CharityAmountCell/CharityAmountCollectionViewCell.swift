//
//  CharityAmountCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class CharityAmountCollectionViewCell: UICollectionViewCell {
    static let identifier = "CharityAmountCollectionViewCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var number: String = "0.0" {
        willSet {
            self.numberLabel.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
