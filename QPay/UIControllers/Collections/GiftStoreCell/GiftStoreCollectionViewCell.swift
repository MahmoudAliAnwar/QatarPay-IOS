//
//  GiftStoreCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class GiftStoreCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GiftStoreCollectionViewCell.self)
    
    @IBOutlet weak var storeImageViewDesign: ImageViewDesign!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    var object: GiftStore! {
        didSet {
            self.storeNameLabel.text = self.object._name
            
//            self.object._imageURL.getImageFromURLString { (status, image) in
//                if status {
//                    self.storeImageViewDesign.image = image!
//                }
//            }
            self.storeImageViewDesign.kf.setImage(with: URL(string: self.object._imageURL))
        }
    }
    
    var isSelectedCell: Bool = false {
        didSet {
            self.storeImageViewDesign.alpha = self.isSelectedCell ? 1.0 : 0.35
            self.storeNameLabel.textColor = self.isSelectedCell ? .appBackgroundColor : .mLight_Gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.storeImageViewDesign.image = .none
    }
}
