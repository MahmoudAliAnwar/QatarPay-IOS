//
//  ProductDetailsImageCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class KuludProductDetailsImageCell: UICollectionViewCell {
    
    static let identifier = String(describing: KuludProductDetailsImageCell.self)
    
    @IBOutlet private weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ image: String) {
        let imageURL = Constants.MEDIAPRODUCT + image
        self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
    }
}
