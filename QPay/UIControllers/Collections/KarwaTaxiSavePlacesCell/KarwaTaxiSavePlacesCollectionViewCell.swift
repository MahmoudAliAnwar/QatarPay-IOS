//
//  KarwaTaxiSavePlacesCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class KarwaTaxiSavePlacesCollectionViewCell: UICollectionViewCell {
    static let identifier = "KarwaTaxiSavePlacesCollectionViewCell"
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescriptionLabel: UILabel!

    var place: KarwaPlace! {
        didSet {
            self.placeImageView.image = place.image
            self.placeNameLabel.text = place.name
            self.placeDescriptionLabel.text = place.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
