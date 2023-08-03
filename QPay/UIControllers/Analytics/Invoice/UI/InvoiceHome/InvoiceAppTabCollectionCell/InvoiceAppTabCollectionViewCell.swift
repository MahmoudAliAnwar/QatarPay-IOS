//
//  InvoiceTabCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceAppTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bottomViewDesign: ViewDesign!
    
    var object: InvoiceHomeViewController.TabModel! {
        willSet {
            self.titleLabel.text = newValue.tab.rawValue
        }
    }
    
    var isTabSelected: Bool = false {
        willSet {
            self.bottomViewDesign.backgroundColor = newValue ? .mBrown : .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
