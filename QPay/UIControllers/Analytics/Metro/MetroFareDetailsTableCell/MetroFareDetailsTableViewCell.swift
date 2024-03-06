//
//  MetroFareDetailsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class MetroFareDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var valueStackView: UIStackView!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var subValueLabel: UILabel!
    
    var isSectionCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftPadding: CGFloat = self.isSectionCell ? 0 : 14
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0))
    }
}
