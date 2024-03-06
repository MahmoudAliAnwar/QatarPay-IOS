//
//  FirstCell.swift
//  QPay
//
//  Created by Mahmoud on 20/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class FirstCell: UICollectionViewCell {
    static let identifier = String(describing: FirstCell.self)
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var cardCodeLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    @IBOutlet weak var cardUserNameLabel: UILabel!
    @IBOutlet weak var cardLoyalityPointsLabel: UILabel!
    @IBOutlet weak var cardCodeStackView: UIStackView!

    func configer(user: User?, balance: String?) {
        if let user = user {
            
            if let accountLevel = user.accountLevel {
                let level = accountLevel.lowercased()
                
                if level == "maroon" {
                    self.cardImageView.image = .ic_maroon_card_home
                    
                }else if level == "business" {
                    self.cardImageView.image = .ic_blue_card_home
                    
                }else if level == "vip" {
                    self.cardImageView.image = .ic_black_card_home
                }
            }
            
            if var code = user.userCode, code.isNotEmpty {
                code.insert(separator: "  ", every: 4)
                self.cardCodeLabel.text = code
            }
            
            if let balance = user.loyalityBalance {
                self.cardLoyalityPointsLabel.text = "\(balance) pts"
            }
            self.balanceLabel.text = balance
            
            // 8/24/2025 10:13:24 AM
            if let expiry = user.qpanExpiry,
               let serverDate = expiry.formatToDate("M/dd/yyyy hh:mm:ss a") {
                self.cardExpiryLabel.text = serverDate.formatDate("MM/yy")
            }
            self.cardUserNameLabel.text = "\(user.firstName ?? "") \(user.lastName ?? "")".uppercased()
        }
    }
}
