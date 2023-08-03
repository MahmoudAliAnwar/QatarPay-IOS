//
//  LibCardImageCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 21/11/2020.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class LibCardImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    
    var image: UIImage? {
        willSet {
            self.cardImageView.image = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
