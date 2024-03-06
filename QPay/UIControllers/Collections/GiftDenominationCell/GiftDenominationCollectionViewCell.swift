//
//  GiftCardCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class GiftDenominationCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GiftDenominationCollectionViewCell.self)

    @IBOutlet weak var storeImageViewDesign: ImageViewDesign!
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardPriceLabel: UILabel!
    
    var object: GiftDenomination! {
        didSet {
            self.cardNameLabel.text = self.object._denomination
            self.cardPriceLabel.text = "\((self.object.price ?? 0.0).formatNumber())"
            
            self.cardImageViewDesign.kf.setImage(with: URL(string: self.object._imageLocationPath))
            self.storeImageViewDesign.kf.setImage(with: URL(string: self.object._storeIcon))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cardImageViewDesign.image = .none
        self.storeImageViewDesign.image = .none
    }
}
