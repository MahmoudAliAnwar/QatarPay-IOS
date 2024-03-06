//
//  CategoryItemCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 27/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryItemCell.self)
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ data: CategoriesScene.Products.Product) {
        self.stopAnimation()
        if data.images.count > 0 {
            let imageURL = Constants.MEDIAPRODUCT + data.images[0]
            self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
        } else {
            self.productImageView.setImageWith(urlString: data.image, placeHolder: #imageLiteral(resourceName: "Logo"))
        }
        self.productNameLabel.text = data.name
        self.productPriceLabel.text = "QAR" + " " + data.price
    }
    
    func startAnimation() {
        self.containerView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
        self.layoutIfNeeded()
    }
    
    func stopAnimation() {
        self.containerView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
}
