//
//  BaseInfoImageCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class BaseInfoImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var object : BaseInfoImageModel? {
        willSet {
            guard let data = newValue else { return }
            self.imageView.kf.setImage(with: URL(string: data.imageURL), placeholder: UIImage.qatar_avatar_ic)
         }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
