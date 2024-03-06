//
//  MyBookCollectionCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class MyBookCollectionCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyBookCollectionCollectionViewCell"
    
    @IBOutlet weak var collectionBackgroundImageView: UIImageView!
    @IBOutlet weak var collectionBackgroundViewDesign: ViewDesign!
    
    @IBOutlet weak var collectionIconImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!

    var collection: MyBookCollection! {
        didSet{
            self.collectionNameLabel.text = collection.name ?? ""
            self.collectionBackgroundViewDesign.backgroundColor = collection.color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
