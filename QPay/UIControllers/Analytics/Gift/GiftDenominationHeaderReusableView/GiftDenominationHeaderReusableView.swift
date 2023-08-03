//
//  GiftCardHeaderReusableView.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class GiftDenominationHeaderReusableView: UICollectionReusableView {
    static let identifier = String(describing: GiftDenominationHeaderReusableView.self)
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.label.text = "Category: Smart Gift Cards"
    }
}
