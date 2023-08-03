//
//  ParkingCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/18/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ParkingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parkingImageView: UIImageView!
    @IBOutlet weak var parkingNameLabel: UILabel!
    
    var parking: Parking! {
        didSet{
            self.parkingNameLabel.text = parking.name?.uppercased() ?? ""
            
            guard let imgUrl = parking.imagURL else { return }
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                self.parkingImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
