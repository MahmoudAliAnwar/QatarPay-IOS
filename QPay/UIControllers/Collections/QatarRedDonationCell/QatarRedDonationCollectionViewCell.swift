//
//  QatarRedDonationCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 24/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol QatarRedDonationCollectionViewCellDelegate: AnyObject {
    func didTapDonationButton(with model: CharityDonation)
}

class QatarRedDonationCollectionViewCell: UICollectionViewCell {
    static let identifier = "QatarRedDonationCollectionViewCell"
    
    @IBOutlet weak var donationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    
    var donation: CharityDonation! {
        didSet {
            self.nameLabel.text = donation._name
            self.targetLabel.text = "target: \(donation._name)"
        }
    }
    
    var delegate: QatarRedDonationCollectionViewCellDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func donateAction(_ sender: UIButton) {
        self.delegate?.didTapDonationButton(with: self.donation!)
    }
}
