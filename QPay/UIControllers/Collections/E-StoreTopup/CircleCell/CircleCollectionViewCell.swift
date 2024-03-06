//
//  CircleCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class CircleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerViewDesign: ViewDesign!
    
    override var isSelected: Bool {
        didSet {
            self.outerViewDesign.borderColor = isSelected ? .appBackgroundColor : .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
