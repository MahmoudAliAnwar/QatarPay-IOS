//
//  XAxisViewCell.swift
//  QPay
//
//  Created by mahmoud ali on 12/01/2024.
//  Copyright © 2024 Dev. Mohmd. All rights reserved.
//

import UIKit

class XAxisViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func config(title: String?){
        
        self.titleLabel.text = title
    }

}
