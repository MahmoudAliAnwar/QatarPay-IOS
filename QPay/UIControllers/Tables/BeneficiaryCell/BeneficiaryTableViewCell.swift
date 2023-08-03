//
//  BeneficiaryTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 14/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class BeneficiaryTableViewCell: UITableViewCell {
    static let identifier = "BeneficiaryTableViewCell"
    
    @IBOutlet weak var beneficiaryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qpanLabel: UILabel!
    
    var beneficiary: Beneficiary! {
        didSet {
            self.nameLabel.text = self.beneficiary._fullName
            self.qpanLabel.text = self.beneficiary._qpan
            
            if let imageURLString = self.beneficiary.profilePicture {
                imageURLString.getImageFromURLString { (status, image) in
                    if status, let img = image {
                        self.beneficiaryImageView.image = img
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.beneficiaryImageView.image = .none
    }
}
