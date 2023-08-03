//
//  CouponCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var amountCouponStackView: UIStackView!
    
    @IBOutlet weak var percentCouponStackView: UIStackView!
    
    @IBOutlet weak var pieceCouponStackView: UIStackView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var amountValueLabel: UILabel!
    
    @IBOutlet weak var percentValueLabel: UILabel!
    
    @IBOutlet weak var pieceValueLabel: UILabel!
    
    @IBOutlet weak var validDateLabel: UILabel!
    
    var object: Coupon! {
        willSet {
            if let date = newValue._couponExpiryDate.formatToDate(ServerDateFormat.Server2.rawValue) {
                self.validDateLabel.text = "Valid until \(date.formatDate("dd MMMM yyyy"))"
            }
            
            self.companyNameLabel.text = newValue._merchantName
            
            self.logoImageView.kf.setImage(with: URL(string: newValue._merchantImageLocation.correctUrlString()))
            
            guard let type = newValue.discountType else { return }
            self.amountCouponStackView.isHidden = type != .Discount
            self.percentCouponStackView.isHidden = type != .Percent
            self.pieceCouponStackView.isHidden = type != .OneFree
            
            switch type {
            case .Discount:
                self.amountValueLabel.text = newValue._couponValue.formatNumber(maxDigits: 1)
            case .Percent:
                self.percentValueLabel.text = newValue._couponValue.formatNumber(maxDigits: 1)
            case .OneFree:
                self.pieceValueLabel.text = newValue._couponValue.formatNumber(maxDigits: 0)
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
