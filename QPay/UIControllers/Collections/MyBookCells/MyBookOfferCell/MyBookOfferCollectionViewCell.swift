//
//  MyBookOfferCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookOfferCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookOfferCollectionViewCell"
    
    @IBOutlet weak var offerTopViewDesign: ViewDesign!
    @IBOutlet weak var offerLogoImageView: UIImageView!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var offerExpiresDateLabel: UILabel!

    var offer: MyBookOffer! {
        didSet{
//            self.offerLogoImageView.image = self.offer.logo
            
            self.offerTitleLabel.text = self.offer.title ?? ""
            self.offerDescriptionLabel.text = self.offer.description ?? ""
            self.offerExpiresDateLabel.text = self.offer._expires
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.offerTopViewDesign.setViewCorners([.topRight, .bottomLeft])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
