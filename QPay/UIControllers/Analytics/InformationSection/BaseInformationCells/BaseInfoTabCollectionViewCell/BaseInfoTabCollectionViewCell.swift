//
//  BaseInfoTabCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class BaseInfoTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameTabLabel: UILabel!
    
    var config: BaseInfoTabsConfig!
    
    var object: BaseInfoTabModel! {
        willSet {
            self.nameTabLabel.text = newValue.title
        }
    }
    
    var isCellSelected: Bool = false {
        willSet {
            self.nameTabLabel.textColor = newValue ? self.config.selectedColor : self.config.unSelectedColor
        }
    }
}
