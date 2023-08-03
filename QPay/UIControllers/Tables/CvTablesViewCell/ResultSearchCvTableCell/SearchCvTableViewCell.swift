//
//  SearchCvTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 11/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol SearchCvTableViewCellDelegate : AnyObject {
//    func didTapMoveTo(_ cell : SearchCvTableViewCell)
}

class SearchCvTableViewCell : UITableViewCell {
    
    @IBOutlet weak var avatarImage   : ImageViewDesign!
    
    @IBOutlet weak var nameLabel     : UILabel!
    
    @IBOutlet weak var jobTitleLabel : UILabel!
    
    @IBOutlet weak var countryLabel  : UILabel!
    
    @IBOutlet weak var companyLabel  : UILabel!
    
    weak var delegate : SearchCvTableViewCellDelegate?
    
    var object: CV! {
        willSet {
            self.nameLabel.text     = newValue._name
            self.jobTitleLabel.text = newValue._currentJobList.first?._jobTitle
            self.countryLabel.text  = newValue._nationality
            self.companyLabel.text  = newValue._currentJobList.first?._companyNamee
            
            if newValue._profilePicture == "" {
                self.avatarImage.image = .ic_avatar
            } else {
                newValue._profilePicture.getImageFromURLString { (status, image) in
                    guard status else { return }
                    self.avatarImage.image = image
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SearchCvTableViewCell {
    
}
