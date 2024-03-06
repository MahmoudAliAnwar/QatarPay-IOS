//
//  ProductTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var QuantityBottomLabel: UILabel!
    @IBOutlet weak var rightPriceLabel: UILabel!
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var rightPriceStackView: UIStackView!
    @IBOutlet weak var rightQuantityStackView: UIStackView!
    @IBOutlet weak var rightContainerView: ViewDesign!
    @IBOutlet weak var rightContainerViewWidth: NSLayoutConstraint!
    
    var cartItem: CartItem! {
        willSet {
            self.productNameLabel.text = newValue.product._name
            self.productDescriptionLabel.text = newValue.product._description
            self.productPriceLabel.text = "\(newValue.quantity.description) X QAR \(newValue.product._price)"
            
            self.productQuantityLabel.text = "\(newValue.quantity)"
            self.QuantityBottomLabel.text = "\(newValue.quantity)"
            
            guard let imgUrl = newValue.product.image else { return }
            self.setProductImage(imgUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerStackView.layoutMargins = .init(top: 6, left: 18, bottom: 6, right: 12)
        self.rightContainerView.borderColor = .systemGray5
        self.rightPriceStackView.isHidden = true
        self.rightQuantityStackView.isHidden = false
        self.productDescriptionLabel.isHidden = false
        self.rightContainerViewWidth.constant = 40
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private func setProductImage(_ imageURL: String) {
        imageURL.getImageFromURLString { (status, image) in
            guard status else { return }
            self.productImageView.image = image
        }
    }
}
