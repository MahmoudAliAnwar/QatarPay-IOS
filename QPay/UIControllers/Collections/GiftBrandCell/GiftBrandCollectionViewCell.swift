//
//  GiftStoreCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

final class GiftBrandCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GiftBrandCollectionViewCell.self)
    
    @IBOutlet weak var brandImageViewDesign: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!

    var object: GiftBrand! {
        didSet {
            self.brandNameLabel.text = self.object._name

            self.brandImageViewDesign.kf.setImage(with: URL(string: self.object._imageLocationPath)) { (result) in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.brandImageViewDesign.image = .none
    }
}
