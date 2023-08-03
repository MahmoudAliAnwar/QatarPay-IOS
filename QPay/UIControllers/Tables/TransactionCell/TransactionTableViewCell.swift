//
//  TransactionTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/4/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var topAmmountLabel: UILabel!
    @IBOutlet weak var rightAmmountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rightTypeLabel: UILabel!
    
    var parent: UIViewController?
    
    private let redColor: UIColor = .systemRed
    private let greenColor: UIColor = .systemGreen
    
    private enum TransactionType {
        case Outgoing
        case Incoming
        case Purchase
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userImageView.image = .qatar_avatar_ic
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(transaction: Transaction) {
        
        if let imgUrl = transaction.destinationImageUrl {
//            imgUrl.getImageFromURLString { (status, image) in
//                if status {
//                    self.userImageView.image = image
//                }
//            }
            self.userImageView.kf.setImage(with: URL(string: imgUrl),placeholder: UIImage.qatar_avatar_ic)

        }
                
        if let type = transaction.type, let username = transaction.destinationUserName {
            if let ammount = transaction.amount, let typeID = transaction.typeID {
                
                let purchaseCaseString = "purchase"
                
                if type.contains(purchaseCaseString) {
                    self.setUsernameByType(.Purchase, username: username)
                    self.setRightAmountByType(.Purchase, ammount: ammount)
                    self.setStatusImageByType(.Purchase)
                    
                }else {
                    if typeID == 7 || ((41...61).contains(typeID) && typeID != 55) {
                        self.setUsernameByType(.Outgoing, username: username)
                        self.setRightAmountByType(.Outgoing, ammount: ammount)
                        self.setStatusImageByType(.Outgoing)
                        
                    }else {
                        self.setUsernameByType(.Incoming, username: username)
                        self.setRightAmountByType(.Incoming, ammount: ammount)
                        self.setStatusImageByType(.Incoming)
                    }
                }
                
                self.topAmmountLabel.isHidden = false
                
                /// Type label
                if let type = transaction.type {
                    self.dateLabel.text = type
                }
                
                /// Top Ammount label
                
                if type.contains(purchaseCaseString) {
                    self.setTopAmountByType(.Purchase, ammount: ammount)
                    
                }else {
                    if typeID == 7 || ((41...61).contains(typeID) && typeID != 55) {
                        self.setTopAmountByType(.Outgoing, ammount: ammount)
                        
                    } else {
                        self.setTopAmountByType(.Incoming, ammount: ammount)
                    }
                }
                
                /// Date label
                // 2020-08-29T11:23:31.027
                if let dateString = transaction.date,
                   let date = dateString.server1StringToDate() {
                    
                    if (self.parent as? HomeViewController) != nil {
                        
                        self.rightTypeLabel.isHidden = true
                        self.descriptionLabel.isHidden = false
                        
                        self.descriptionLabel.text = date.formatDate("MMMM dd, yyyy")
                        
                    }else if (self.parent as? TransactionsViewController) != nil {
                        
                        self.rightTypeLabel.isHidden = false
                        self.descriptionLabel.isHidden = true
                        
                        self.rightTypeLabel.text = date.formatDate("dd MMM hh:mm a")
                    }
                }
            }
        }
    }
    
    private func setUsernameByType(_ type: TransactionType, username: String) {
        
        self.usernameLabel.text = username
        
        switch type {
        case .Outgoing, .Incoming:
            self.usernameLabel.textColor = .black
        case .Purchase:
            self.usernameLabel.textColor = .systemBlue
        }
    }
    
    private func setTopAmountByType(_ type: TransactionType, ammount: Double) {
        
        self.topAmmountLabel.text = "\(ammount.description) QAR"

        switch type {
        case .Outgoing, .Purchase:
            self.topAmmountLabel.textColor = self.redColor
            self.setStatusImageByType(type)
            
        case .Incoming:
            self.topAmmountLabel.textColor = self.greenColor
            self.setStatusImageByType(type)
        }
    }
    
    private func setStatusImageByType(_ type: TransactionType) {
        
        switch type {
        case .Outgoing:
            self.statusImageView.image = #imageLiteral(resourceName: "ic_transaction_out-1")
            
        case .Incoming:
            self.statusImageView.image = #imageLiteral(resourceName: "ic_transaction_in-1")
            
        case .Purchase:
            self.statusImageView.image = #imageLiteral(resourceName: "ic_cart_transactions")
        }
    }
    
    private func setRightAmountByType(_ type: TransactionType, ammount: Double) {
        
        let outAmmount = "- Noqs \(ammount.description)"
        let inAmmount = "+ Noqs \(ammount.description)"
        
        switch type {
        case .Outgoing, .Purchase:
            self.rightAmmountLabel.textColor = self.redColor
            self.rightAmmountLabel.text = outAmmount
            
        case .Incoming:
            self.rightAmmountLabel.textColor = self.greenColor
            self.rightAmmountLabel.text = inAmmount
        }
    }
}
