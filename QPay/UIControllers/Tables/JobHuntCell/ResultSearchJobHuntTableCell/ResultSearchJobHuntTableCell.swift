//
//  ResultSearchJobHuntTableCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

class ResultSearchJobHuntTableCell: UITableViewCell {
    
    @IBOutlet weak var imageViewDesingn: ImageViewDesign!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var jobTitelLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    
    var objectJob: JobHunterList? {
        willSet {
            guard let data = newValue else { return }
            self.nameLabel.text = data._employerName
            self.jobTitelLabel.text = data._jobTitle
            if let postDate = data._postDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
                self.postDateLabel.text = "\(postDate.formatDate("MMM d, yyyy"))"
            }
            self.imageViewDesingn.kf.setImage(with: URL(string: data._profilePictureURL), placeholder: UIImage.job_hunt_profile_image)
            
        }
    }
    //2023-06-03T01:40:43.447
    //yyyy-MM-ddTHH:mm:ss.SSS
    
    var objectEmployer: EmployerList? {
        willSet {
            guard let data = newValue else { return }
            self.nameLabel.text = data._employer_name
            self.jobTitelLabel.text = data._job_title
            if let postDate = data._postDate.convertFormatStringToDate(ServerDateFormat.Server1.rawValue) {
                self.postDateLabel.text = "\(postDate.formatDate("MMM d, yyyy"))"
            }
            self.imageViewDesingn.kf.setImage(with: URL(string: data._logo), placeholder: UIImage.ic_avatar)
            
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
