//
//  ExpertiseTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol KeyValueTableViewCellDelegate: AnyObject {

    func didTapEditCellExpertise(_ cell: KeyValueTableViewCell)
}

class KeyValueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var editStackView: UIStackView!
    
    weak var delegate: KeyValueTableViewCellDelegate?
    
//    var object: ShowCVDetailsViewController.CellConfiguration! {
//        willSet {
//            self.iconImageView.image =       newValue.type.icon
//            self.backgroundImageView.image = newValue.type.bg
//            self.nameLabel.text =            newValue.type.rawValue
//            self.keyLabel.text =             newValue.data
//            self.valueLabel.text =           newValue.data
//            self.editStackView.isHidden =    !newValue.type.hasEditBtn
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

extension KeyValueTableViewCell {
    
    @IBAction func editAction(_ sender: UIButton) {
        self.delegate?.didTapEditCellExpertise(self)
    }
}
