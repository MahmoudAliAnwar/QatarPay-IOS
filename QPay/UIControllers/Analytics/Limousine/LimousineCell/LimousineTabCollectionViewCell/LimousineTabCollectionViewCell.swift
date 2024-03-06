//
//  LimousineTabCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class LimousineTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameTabLabel: UILabel!
    
    var object: LimousineTab! {
        willSet {
            self.nameTabLabel.text = newValue._ojraBuisnessCategory
        }
    }
    
    var isCellSelected: Bool = false {
        willSet {
            self.nameTabLabel.textColor = newValue ? .systemYellow : .white
        }
    }
}
