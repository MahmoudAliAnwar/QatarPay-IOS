//
//  KuludProductCollectionViewCell.swift
//  kulud
//
//  Created by Hussam Elsadany on 10/03/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import UIKit

protocol KuludProductCollectionViewCellDelegate: AnyObject {
    func product(cell: KuludProductCollectionViewCell, didTapAddToCart item: IndexPath)
    func product(cell: KuludProductCollectionViewCell, didChangeQuantityFor item: IndexPath, quantity: Int)
}

class KuludProductCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: KuludProductCollectionViewCell.self)
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var quatityLabel: UILabel!
    @IBOutlet private weak var quatityView: UIView!
    @IBOutlet private weak var addToCartView: UIView!
    
    var delegate: KuludProductCollectionViewCellDelegate? = nil
    private var myIndexPath: IndexPath!
    private var product: HomeScene.Collections.Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(_ data: HomeScene.Collections.Product, indexPath: IndexPath) {
        self.product = data
        self.myIndexPath = indexPath
        self.stopAnimation()
        self.productNameLabel.text = data.name
        self.productPriceLabel.text = "QAR" + " " + data.price
        let imageURL = Constants.MEDIAPRODUCT + data.image
        self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
        
        self.quatityView.isHidden = !data.isCart
        self.addToCartView.isHidden = data.isCart
        self.quatityLabel.text = "\(data.quantity)"
    }
    
    func startAnimation() {
        self.containerView.subviews.forEach({$0.isSkeletonable = true; $0.showAnimatedGradientSkeleton()})
        self.layoutIfNeeded()
    }
    
    func stopAnimation() {
        self.containerView.subviews.forEach({$0.isSkeletonable = false; $0.hideSkeleton()})
    }
    
    @IBAction func addToProduct(_ sender: Any) {
        self.delegate?.product(cell: self, didTapAddToCart: self.myIndexPath)
    }
    
    @IBAction func increaseCount(_ sender: Any) {
        self.delegate?.product(cell: self, didChangeQuantityFor: self.myIndexPath, quantity: self.product.quantity + 1)
    }
    
    @IBAction func decreaseCount(_ sender: Any) {
        self.delegate?.product(cell: self, didChangeQuantityFor: self.myIndexPath, quantity: self.product.quantity - 1)
    }
}
