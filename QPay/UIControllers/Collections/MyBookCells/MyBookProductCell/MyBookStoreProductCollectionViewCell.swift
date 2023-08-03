//
//  MyBookProductCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

final class MyBookStoreProductCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookStoreProductCollectionViewCell"
    
    @IBOutlet weak var productLogoImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPlaceLabel: UILabel!
    @IBOutlet weak var productKeywordLabel: UILabel!
    
    var product: MyBookProduct! {
        didSet {
            self.productNameLabel.text = self.product.name ?? ""
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @IBAction func loveAction(_ sender: UIButton) {
        
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
}
