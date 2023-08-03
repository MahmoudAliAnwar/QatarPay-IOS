//
//  SkillsTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol SkillsTableViewCellDelegate: AnyObject {
    func didTapEditCellSkills(_ cell : SkillsTableViewCell )
}

class SkillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLable: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var valueLable: UILabel!
    
    var delegate:SkillsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell( icon : UIImage , name : String , background : UIImage , value : String){
        self.iconImageView.image =        icon
        self.backgroundImageView.image =  background
        self.nameLable.text =             name
        self.valueLable.text =            value
        
    }
    
}

extension SkillsTableViewCell {
    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.didTapEditCellSkills(self)
    }
}
