//
//  PeesonalResumeHeaderCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class PeesonalResumeHeaderCell: UITableViewCell {
    @IBOutlet weak var backgroundImage : UIImageView!
    
    @IBOutlet weak var iconImageView : UIImageView!
    
    @IBOutlet weak var nameLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
