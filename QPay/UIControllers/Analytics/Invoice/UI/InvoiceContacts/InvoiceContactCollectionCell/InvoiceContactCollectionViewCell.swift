//
//  InvoiceContactCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceContactCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contactImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactCompanyLabel: UILabel!
    
    var object: InvoiceContact! {
        willSet {
            self.contactNameLabel.text = newValue._name
            self.contactCompanyLabel.text = newValue._company
            self.contactImageViewDesign.image = #imageLiteral(resourceName: "ic_avatar")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
