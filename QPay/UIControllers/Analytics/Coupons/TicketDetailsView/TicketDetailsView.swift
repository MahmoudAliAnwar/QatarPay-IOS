//
//  TicketDetailsView.swift
//  QPay
//
//  Created by Mohammed Hamad on 16/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class TicketDetailsView: UIView {
    
    @IBOutlet weak var amountCouponStackView: UIStackView!
    
    @IBOutlet weak var percentCouponStackView: UIStackView!
    
    @IBOutlet weak var pieceCouponStackView: UIStackView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var amountValueLabel: UILabel!
    
    @IBOutlet weak var percentValueLabel: UILabel!
    
    @IBOutlet weak var pieceValueLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    
    @IBOutlet weak var longDescriptionLabel: UILabel!
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    @IBOutlet weak var barcodeNumberLabel: UILabel!
    
    @IBOutlet weak var validDateLabel: UILabel!
    
    var object: CouponDetails! {
        willSet {
            if let date = newValue._couponExpiryDate.formatToDate(ServerDateFormat.Server2.rawValue) {
                self.validDateLabel.text = "Valid until \(date.formatDate("dd MMMM yyyy"))"
            }
            
            self.companyNameLabel.text = newValue._merchantName
            
            self.shortDescriptionLabel.text = newValue._shortDescription
            self.longDescriptionLabel.text = newValue._longDescription
            
            self.logoImageView.kf.setImage(with: URL(string: newValue._merchantImageLocation.correctUrlString()))
            self.barcodeImageView.kf.setImage(with: URL(string: newValue._couponImageLocation.correctUrlString()))
            
            self.barcodeNumberLabel.text = newValue._couponNumber
            
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    private func setupView() {
        guard let view = self.loadViewFromNib() else { return }
        self.addSubview(view)
        view.frame = self.bounds
    }
}
