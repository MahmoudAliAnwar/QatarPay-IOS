//
//  AmmountCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class AmmountCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var radioButton: CheckBox!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        radioButton.style = .circle
        radioButton.borderStyle = .rounded
        radioButton.borderWidth = 1
        
        self.layer.cornerRadius = 12
    }

    public func setupData(ammount: Amount) {
        self.paymentLabel.text = ammount.payment.description
        self.bgLabel.text = ammount.payment.description
    }
    
    private func setCellShadow() {
        
//        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 5.0)//CGSizeMake(0, 2.0);
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
    }
}
