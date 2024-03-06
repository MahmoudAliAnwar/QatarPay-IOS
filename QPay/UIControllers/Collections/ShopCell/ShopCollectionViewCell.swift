//
//  ShopCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol ShopCollectionViewCellDelegate: AnyObject {
    func didTapShowHideButton(_ cell: ShopCollectionViewCell, for shop: Shop)
    func didTapShareButton(_ cell: ShopCollectionViewCell, for shop: Shop)
    func didTapEditButton(_ cell: ShopCollectionViewCell, for shop: Shop)
    func didTapProductsButton(_ cell: ShopCollectionViewCell, for shop: Shop)
    func didTapOrdersButton(_ cell: ShopCollectionViewCell, for shop: Shop)
}

class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopStatusImageView: UIImageView!
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopDescriptionLabel: UILabel!
    @IBOutlet weak var shopDateLabel: UILabel!
    
    @IBOutlet weak var activeShopView: UIView!
    @IBOutlet weak var shopActionsStackView: UIStackView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var shareView: UIView!
    weak var delegate: ShopCollectionViewCellDelegate?
    
    var shop: Shop! {
        didSet {
            if let isActive = shop.isActive {
                self.isActiveToggleBtn(isActive)
            }
            if let name = shop.name {
                self.shopNameLabel.text = name
            }
            
            if let desc = shop.description {
                self.shopDescriptionLabel.text = desc
            }
            
            // 2020-09-25T00:00:00
            if let dateString = shop.creationDate,
               let resDate = dateString.server2StringToDate() {
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "MM/dd/yyyy"
                
                let myDate = myFormatter.string(from: resDate)
                self.shopDateLabel.text = "Created: \(myDate)"
            }
            
            guard let imgUrl = shop.logo else { return }
            imgUrl.getImageFromURLString { (status, image) in
                guard status else { return }
                self.shopImageView.image = .none
                self.shopImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.shopImageView.image = .none
    }
    
    // MARK: - ACTIONS
    
    @IBAction func showHideAction(_ sender: UIButton) {
        self.isActiveToggleBtn(!self.activeShopView.isHidden)
        self.delegate?.didTapShowHideButton(self, for: self.shop)
    }

    @IBAction func shareAction(_ sender: UIButton) {
        self.delegate?.didTapShareButton(self, for: self.shop)
    }

    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.didTapEditButton(self, for: self.shop)
    }

    @IBAction func productsAction(_ sender: UIButton) {
        self.delegate?.didTapProductsButton(self, for: self.shop)
    }

    @IBAction func ordersAction(_ sender: UIButton) {
        self.delegate?.didTapOrdersButton(self, for: self.shop)
    }
}

// MARK: - PRIVATE FUNCTIONS

extension ShopCollectionViewCell {
    
    private func isActiveToggleBtn(_ status: Bool) {
        self.shopStatusImageView.image = status ? .eye : .eye_slash
        self.shareView.isHidden = !status
        self.activeShopView.isHidden = status
    }
}
