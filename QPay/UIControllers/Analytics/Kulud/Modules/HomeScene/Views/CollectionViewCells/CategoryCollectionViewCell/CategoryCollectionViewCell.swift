//
//  CategoryCollectionViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit
import SkeletonView

class CategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.frame.height / 2
    }
    
    func updateCell(_ viewModel: HomeScene.Categories.Category) {
        self.stopAnimation()
        self.titleLabel.text = viewModel.name
        let imageURL = Constants.MEDIACATEGORY + viewModel.image
        self.imageView.setImageWith(urlString: imageURL)
        self.layoutIfNeeded()
    }
    
    func startAnimation() {
        self.imageContainerView.layer.borderWidth = 0
        self.contentView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
        self.layoutIfNeeded()
    }
    
    func stopAnimation() {
        self.imageContainerView.layer.borderWidth = 2
        self.contentView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
}
