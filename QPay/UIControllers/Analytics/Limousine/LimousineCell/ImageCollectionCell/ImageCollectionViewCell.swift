//
//  ImageCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    //TODO: Fix
    var object : CarTypeDetails? {
        willSet {
            guard let data = newValue else { return }
            guard let image = data.carImageLocation, image.isNotEmpty else { return }
            self.imageView.kf.setImage(with: URL(string: image), placeholder: UIImage.ic_avatar)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
