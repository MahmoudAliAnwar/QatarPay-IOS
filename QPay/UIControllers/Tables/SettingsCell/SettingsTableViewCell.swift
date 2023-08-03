//
//  SettingsTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/5/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemArrowImageView: UIImageView!
    @IBOutlet weak var itemBottomView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setupData(item: SettingsModel) {
        itemImageView.image = item.image
        itemTitle.text = item.title
        if item.title == SettingsItems.logout.rawValue {
            self.itemArrowImageView.image = .none
            self.itemBottomView.backgroundColor = .clear
        }
    }
}
