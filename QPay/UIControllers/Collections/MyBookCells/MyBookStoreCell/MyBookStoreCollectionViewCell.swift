//
//  MyBookStoreCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 11/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookStoreCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookStoreCollectionViewCell"
    
    @IBOutlet weak var storeLogoImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeLocationLabel: UILabel!
    @IBOutlet weak var storeKeywordLabel: UILabel!
    
    var store: MyBookStore! {
        didSet {
            self.storeNameLabel.text = self.store.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    
    @IBAction func loveAction(_ sender: UIButton) {
        
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
    }
}
