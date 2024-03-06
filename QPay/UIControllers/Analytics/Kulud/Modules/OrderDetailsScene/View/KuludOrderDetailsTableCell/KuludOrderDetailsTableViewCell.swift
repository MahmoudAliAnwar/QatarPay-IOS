//
//  KuludOrderDetailsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class KuludOrderDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceQuantityLabel: UILabel!
    
    var object: KuludOrderDetails! {
        willSet {
            self.productNameLabel.text = newValue.product?.localizedName
            self.productPriceQuantityLabel.text = "QAR \(newValue.product?.price ?? 0.0) x \(newValue._quantity)"
            let imageURL = Constants.MEDIAPRODUCT + (newValue.product?.productsImages?.first?.image ?? "")
            self.productImageView.setImageWith(urlString: imageURL, placeHolder: #imageLiteral(resourceName: "Logo"))
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
}
