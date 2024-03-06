//
//  TopupTypeCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class TopupTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    var object: TopupType! {
        didSet {
            self.typeImageView.image = object.image
            self.typeNameLabel.text = object.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerViewDesign.cornerRadius = (self.contentView.height/10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
