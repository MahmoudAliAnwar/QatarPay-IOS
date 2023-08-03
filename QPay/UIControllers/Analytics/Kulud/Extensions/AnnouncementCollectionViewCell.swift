//
//  AnnouncementCollectionViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

class AnnouncementCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: AnnouncementCollectionViewCell.self)
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ viewModel: HomeScene.Advertisements.Advertisement) {
        self.stopAnimation()
        let imageURL = Constants.MEDIAADS + viewModel.image
        self.imageView.setImageWith(urlString: imageURL)
    }

    func startAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
        self.layoutIfNeeded()
    }
    
    func stopAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
}
