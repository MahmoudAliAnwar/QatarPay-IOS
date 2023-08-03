//
//  KarwaBusCardCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 24/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView

class KarwaBusCardFSPagerViewCell: FSPagerViewCell {
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    var card: KarwaBusCard! {
        didSet {
            guard let imagePath = self.card.thumbnail else { return }
            self.cardImageViewDesign.kf.setImage(with: URL(string: imagePath.correctUrlString()), placeholder: UIImage.ic_karwa_card)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cardImageViewDesign.cornerRadius = self.cardImageViewDesign.height / 16
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
