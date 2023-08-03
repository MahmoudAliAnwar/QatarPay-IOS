//
//  MetroCardFSPagerViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit
import FSPagerView

class MetroCardFSPagerViewCell: FSPagerViewCell {
    
    @IBOutlet weak var cardImageViewDesign: ImageViewDesign!
    
    var card: MetroCard! {
        didSet {
            guard let imagePath = self.card.thumbnail else { return }
            self.cardImageViewDesign.kf.setImage(with: URL(string: imagePath.correctUrlString()), placeholder: UIImage.ic_metro_rail_card)
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
