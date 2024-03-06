//
//  ProfileTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfileView: ImageViewDesign!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var publicCheckBox: CheckBox!
    
    @IBOutlet weak var privateCheckBox: CheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.publicCheckBox.style = .circle
        self.publicCheckBox.borderStyle = .rounded
        self.publicCheckBox.tintColor = .black
        self.publicCheckBox.borderWidth = 1
        
        self.privateCheckBox.style = .circle
        self.privateCheckBox.borderStyle = .rounded
        self.privateCheckBox.tintColor = .black
        self.privateCheckBox.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ProfileTableViewCell {
    @IBAction func onTapChangeImage(_ sender : UIButton){
        
    }
}
