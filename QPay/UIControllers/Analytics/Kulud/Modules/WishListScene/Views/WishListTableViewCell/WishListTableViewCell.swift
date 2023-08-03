//
//  WishListTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 05/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol WishListTableViewCellDelegate {
    func wishList(cell: WishListTableViewCell, didTapMoveToCartFor item: IndexPath)
    func wishList(cell: WishListTableViewCell, didTapDeleteFor item: IndexPath)
}

class WishListTableViewCell: UITableViewCell {

    static let identifier = String(describing: WishListTableViewCell.self)
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    
    public var delegate: WishListTableViewCellDelegate? = nil
    private var cellIndex: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ viewModel: WishListSceneScene.Products.Product, indexPath: IndexPath) {
        self.cellIndex = indexPath
        self.stopAnimation()
        if viewModel.images.count > 0 {
            let imageURL = Constants.MEDIAPRODUCT + viewModel.images[0]
            self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
        } else {
            self.productImageView.setImageWith(urlString: viewModel.image, placeHolder: #imageLiteral(resourceName: "Logo"))
        }
        self.productNameLabel.text = viewModel.name
        self.productPriceLabel.text = "QAR" + " " + viewModel.price
    }
    
    func startAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
    }
    
    func stopAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
    
    @IBAction private func deleteAction(_ sender: Any) {
        self.delegate?.wishList(cell: self, didTapDeleteFor: cellIndex)
    }
    
    @IBAction private func moveToCart(_ sender: Any) {
        self.delegate?.wishList(cell: self, didTapMoveToCartFor: cellIndex)
    }
}
