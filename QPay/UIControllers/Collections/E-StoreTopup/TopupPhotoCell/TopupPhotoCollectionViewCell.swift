//
//  TopupPhotoCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class TopupPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    @IBOutlet weak var typeImageViewDesign: ImageViewDesign!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    var object: TopupType! {
        didSet {
            self.typeImageViewDesign.image = object.image
            self.typeNameLabel.text = object.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let corner = self.contentView.height/18
        self.containerViewDesign.cornerRadius = corner
        self.typeImageViewDesign.cornerRadius = corner
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
