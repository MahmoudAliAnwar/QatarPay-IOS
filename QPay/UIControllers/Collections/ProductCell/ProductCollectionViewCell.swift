//
//  ProductCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol ProductsCollectionCellDelegate: AnyObject {
    func didAddProductQuantity(for cell: ProductCollectionViewCell, item: CartItem)
    func didRemoveProductQuantity(for cell: ProductCollectionViewCell, item: CartItem)
    func didTapEditProduct(for cell: ProductCollectionViewCell, item: CartItem)
    func didTapShowHideProduct(for cell: ProductCollectionViewCell, item: CartItem)
    func didTapDeleteProduct(for cell: ProductCollectionViewCell, item: CartItem)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activeProductView: UIView!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productStatusImageView: UIImageView!
    
    @IBOutlet weak var deleteProductView: UIView!
    
    weak var delegate: ProductsCollectionCellDelegate?
    
    var selectedShop: Shop!
    var productStatus: Bool = false
    
    var cartItem: CartItem! {
        willSet {
            self.productNameLabel.text = newValue.product._name
            self.productDescriptionLabel.text = newValue.product._description
            self.productPriceLabel.text = "\(newValue.product._price) QAR"
            self.productQuantityLabel.text = "\(newValue.quantity)"
            
            if let isActive = newValue.product.isActive {
                self.isActiveToggleBtn(isActive)
                self.productStatus = isActive
            }
            
            if let img = newValue.product.image {
                img.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.productImageView.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.productImageView.image = .none
    }
    
    // MARK: - ACTIONS
    
    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.didTapEditProduct(for: self, item: self.cartItem)
    }
    
    @IBAction func showHideAction(_ sender: UIButton) {
        self.productStatus = !self.productStatus
        self.isActiveToggleBtn(self.productStatus)
        
        self.delegate?.didTapShowHideProduct(for: self, item: self.cartItem)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate?.didTapDeleteProduct(for: self, item: self.cartItem)
    }
    
    @IBAction func addQuantityAction(_ sender: UIButton) {
        let quantity = self.getProductQuantity()
        self.productQuantityLabel.text = (quantity + 1).description
        
        self.delegate?.didAddProductQuantity(for: self, item: self.cartItem)
    }
    
    @IBAction func removeQuantityAction(_ sender: UIButton) {
        
        let quantity = self.getProductQuantity()
        if quantity > 0 {
            self.productQuantityLabel.text = (quantity - 1).description
            
            self.delegate?.didRemoveProductQuantity(for: self, item: self.cartItem)
        }
    }
    
    private func getProductQuantity() -> Int {
        if let quantity = Int(self.productQuantityLabel.text!) {
            return quantity
        }
        return 0
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ProductCollectionViewCell {
    
    private func isActiveToggleBtn(_ status: Bool) {
        self.productStatusImageView.image = status ? .eye : .eye_slash
        self.activeProductView.isHidden = status
    }
}
