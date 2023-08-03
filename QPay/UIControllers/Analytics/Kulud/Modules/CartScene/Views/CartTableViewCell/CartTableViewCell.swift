//
//  CartTableViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol CartTableViewCellDelegate {
    func cartTableView(cell: CartTableViewCell, didTapChangeQuantityFor item: IndexPath)
    func cartTableView(cell: CartTableViewCell, didTapRemoveFor item: IndexPath)
}

class CartTableViewCell: UITableViewCell {

    static let identifier = String(describing: CartTableViewCell.self)
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    
    public var delegate: CartTableViewCellDelegate? = nil
    private var cellIndexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(_ data: CartScene.Product.Product, indexPath: IndexPath) {
        self.cellIndexPath = indexPath
        self.stopAnimation()
        if data.images.count > 0 {
            let imageURL = Constants.MEDIAPRODUCT + data.images[0]
            self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
        } else {
            self.productImageView.setImageWith(urlString: data.image, placeHolder: #imageLiteral(resourceName: "Logo"))
        }
        self.productNameLabel.text = data.name
        self.productPriceLabel.text = "QAR" + " " + data.price
        self.quantityLabel.text = "\(data.quantity)"
    }
    
    func startAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
    }
    
    func stopAnimation() {
        self.contentView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
    
    @IBAction private func changeQuantity(_ sender: Any) {
        self.delegate?.cartTableView(cell: self, didTapChangeQuantityFor: self.cellIndexPath)
    }
    
    @IBAction func remove(_ sender: Any) {
        self.delegate?.cartTableView(cell: self, didTapRemoveFor: self.cellIndexPath)
    }
}
