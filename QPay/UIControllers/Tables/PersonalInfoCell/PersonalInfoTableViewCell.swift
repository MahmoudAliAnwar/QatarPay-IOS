//
//  PersonalInfoCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

final class PersonalInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var verificationImageView: UIImageView!
    @IBOutlet weak var actionImageView: UIImageView!
    
    var model: PersonalInfoViewController.Model! {
        willSet (model) {
            self.titleLabel.text = model.option.title
            self.valueLabel.text = model.value
            self.setCellDesign(to: model.option)
            self.isHideDescriptionLabel(model.description == nil)
            
            guard let desc = model.description else { return }
            self.descriptionLabel.text = desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.actionImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didTapActionIcon(_:)))
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    @objc private func didTapActionIcon(_ gesture: UIGestureRecognizer) {
        self.model.action()
    }
    
    private func setCellDesign(to option: PersonalInfoViewController.Option) {
        
        switch option {
        case .Email(let isVerified):
            self.verificationImageView.image = isVerified ? .ic_verified_personal_info : .ic_unverified_personal_info
            self.actionImageView.image = .ic_edit_personal_info
            break
        case .Mobile(let isVerified):
            self.verificationImageView.image = isVerified ? .ic_verified_personal_info : .ic_unverified_personal_info
            self.actionImageView.image = .ic_edit_personal_info
            break
        case .Pin:
            self.actionImageView.image = .ic_reset_personal_info
            self.verificationImageView.isHidden = true
            break
        case .QID(let isVerified):
            self.verificationImageView.image = isVerified ? .ic_verified_personal_info : .ic_unverified_personal_info
            self.actionImageView.image = .ic_eye_personal_info
            break
        case .Passport(let isVerified):
            self.verificationImageView.image = isVerified ? .ic_verified_personal_info : .ic_unverified_personal_info
            self.actionImageView.image = .ic_eye_personal_info
            break
        case .Gender:
            self.actionImageView.image = .ic_edit_personal_info
            break
        case .Nationality:
            break
        }
    }
    
    private func isHideDescriptionLabel(_ status: Bool) {
        self.descriptionLabel.isHidden = status
    }
}
