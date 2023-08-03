//
//  MyBookStoresCategoryCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookStoresCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookStoresCategoryCollectionViewCell"
    
    @IBOutlet weak var categoryBackgroundImageViewDesign: ImageViewDesign!
    @IBOutlet weak var blackBackgroundViewDesign: ViewDesign!
    @IBOutlet weak var whiteForegroudViewDesign: ViewDesign!
    @IBOutlet weak var categoryNameLabel: UILabel!

    var category: MyBookCategory! {
        didSet {
            self.categoryNameLabel.text = self.category.name ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let corner: CGFloat = self.height/6
        
        self.categoryBackgroundImageViewDesign.cornerRadius = corner
        self.blackBackgroundViewDesign.cornerRadius = corner
        self.whiteForegroudViewDesign.cornerRadius = corner
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
