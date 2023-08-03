//
//  StocksTabCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class StocksTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgTab: UIImageView!
    
    var object: StocksHomeViewController.Tabs! {
        willSet {
//            self.title.text = newValue.rawValue
//            self.title.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            self.bgTab.image = newValue.imageBG
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
