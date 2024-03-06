//
//  KuludAddressTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class KuludAddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressName: UILabel!
    
    @IBOutlet weak var addressLocation: UILabel!
    
    @IBOutlet weak var selectedCheckBox: CheckBox!
    
    var object: Address! {
        willSet {
            self.addressName.text = newValue._name
            self.addressLocation.text = newValue._streetName
        }
    }
    
    var isChecked: Bool = false {
        willSet {
            self.selectedCheckBox.isChecked = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectedCheckBox.borderStyle = .rounded
        self.selectedCheckBox.borderWidth = 1
        self.selectedCheckBox.style = .circle
        self.selectedCheckBox.checkmarkColor = .black
        self.selectedCheckBox.checkedBorderColor = .black
        self.selectedCheckBox.tintColor = .black
        self.selectedCheckBox.uncheckedBorderColor = .black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
