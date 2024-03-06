//
//  MoneyTransferActionCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

struct MoneyTransferAction {
    let image: UIImage
    let title: String
    let description: String
    let buttonTitle: String
    let actionClosure: () -> Void
}

class MoneyTransferActionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var actionImageView: UIImageView!
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var actionDescriptionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var action: MoneyTransferAction! {
        didSet {
            self.actionImageView.image = action.image
            self.actionTitleLabel.text = action.title
            self.actionDescriptionLabel.text = action.description
            self.actionButton.setTitle(action.buttonTitle, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - ACTIONS
    
    @IBAction func buttonAction(_ sender: UIButton) {
//        print("Action")
    }
}
