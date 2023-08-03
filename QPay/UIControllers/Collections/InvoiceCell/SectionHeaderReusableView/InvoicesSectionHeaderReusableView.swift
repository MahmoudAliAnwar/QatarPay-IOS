//
//  SectionHeader.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class InvoicesSectionHeaderReusableView: UICollectionReusableView {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: String! {
        didSet {
            self.dateLabel.text = date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
