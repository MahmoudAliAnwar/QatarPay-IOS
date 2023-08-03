//
//  MyBookCategoryCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookCategoryCollectionViewCell"
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!

    var category: MyBookCategory! {
        didSet{
            self.categoryNameLabel.text = category.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
