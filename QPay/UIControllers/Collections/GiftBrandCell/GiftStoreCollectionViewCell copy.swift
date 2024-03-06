//
//  GiftStoreCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit
import SDWebImage

class GiftStoreCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GiftStoreCollectionViewCell.self)
    
    @IBOutlet weak var storeImageViewDesign: ImageViewDesign!
    @IBOutlet weak var storeNameLabel: UILabel!

    var object: GiftStore! {
        didSet {
            self.storeNameLabel.text = self.object._name

            self.storeImageViewDesign.sd_setImage(with: URL(string: self.object._imageURL)) { (image, error, cacheType, url) in
                guard error == nil else {
                    print("ERROR \(error!.localizedDescription)")
                    return
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
