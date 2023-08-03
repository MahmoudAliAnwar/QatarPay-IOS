//
//  MyOrderCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/10/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameFirstLetterLabel: UILabel!
    @IBOutlet weak var nameFirstLetterView: ViewDesign!
    @IBOutlet weak var orderUserNameLabel: UILabel!
    @IBOutlet weak var ordersCountLabel: UILabel!
    
    var color: UIColor! {
        didSet {
            self.nameFirstLetterView.backgroundColor = color
            self.nameFirstLetterView.shadowColor = color
        }
    }
    
    var order: Order! {
        didSet {
            if let customerName = order.customerName, let firstCharacter = customerName.first {
                self.nameFirstLetterLabel.text = String.init(firstCharacter)
                self.orderUserNameLabel.text = customerName
            }
            self.ordersCountLabel.text = "Items Ordered: \(order.orderDetails?.count ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
