//
//  EstoreTopupAmountCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class EstoreTopupAmountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var phpAmountLabel: UILabel!
    @IBOutlet weak var phpCurrencyLabel: UILabel!
    @IBOutlet weak var qarAmountLabel: UILabel!

    var object: MSISDNProduct! {
        didSet {
            self.phpAmountLabel.text = object._productList
            if let cost = Double(object._costPrice) {
                self.qarAmountLabel.text = "\(cost.formatNumber()) QAR"
            }
        }
    }

    var destinationCurrency: String! {
        didSet {
            self.phpCurrencyLabel.text = self.destinationCurrency
        }
    }
    
    var cellBorderWidth: CGFloat? {
        didSet {
            self.contentView.layer.borderWidth = self.cellBorderWidth ?? 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerViewDesign.cornerRadius = (self.width/10)
        self.contentView.layer.borderColor = UIColor.appBackgroundColor.cgColor
        self.contentView.layer.cornerRadius = (self.width/10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
