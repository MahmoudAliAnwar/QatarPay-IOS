//
//  CVHeaderViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol CVHeaderViewCellDelegate: AnyObject {
    func didTapLock(_ cell: CVHeaderViewCell)
    func didTapShare(_ cell: CVHeaderViewCell)
    func didTapEdit(_ cell: CVHeaderViewCell)
}

class CVHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var avaterImageView: ImageViewDesign!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var universityLabel: UILabel!
    
    @IBOutlet weak var stackAction: UIStackView!
    
    weak var delegate: CVHeaderViewCellDelegate?
    
    var object: CV? {
        willSet {
            guard let cv = newValue else { return }
            let urlImagr = cv._profilePicture
            urlImagr.getImageFromURLString { (status, image) in
                guard status else { return }
                self.avaterImageView.image = image
            }
            self.nameLabel.text = cv._name
            self.jobTitleLabel.text = cv._currentJobList.first?.jobTitle
            self.countryLabel.text = cv._currentJobList.first?.country
            self.universityLabel.text = cv._educationList.first?.educationUniversity
            
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

extension CVHeaderViewCell {
    
    @IBAction func lockAction(_ sender: UIButton) {
        self.delegate?.didTapLock(self)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        self.delegate?.didTapShare(self)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.didTapEdit(self)
    }
}


extension String {
    
    func stringToImage(_ handler: @escaping ((UIImage?)->())) {
        if let url = URL(string: self) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    handler(image)
                }
            }.resume()
        }
    }
}
