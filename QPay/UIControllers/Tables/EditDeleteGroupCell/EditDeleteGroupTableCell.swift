//
//  EditDeleteGroupTableCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol EditDeleteGroupTableCellDelegate: AnyObject {
    
    func didTapDeleteGroup (_ cell : EditDeleteGroupTableCell ,for group: Group)
    func didTapEditGroup   (_ cell : EditDeleteGroupTableCell ,for group: Group)
}

class EditDeleteGroupTableCell: UITableViewCell {
    @IBOutlet weak var nameGroupLabel: UILabel!
    
    weak var delegate: EditDeleteGroupTableCellDelegate?
    
    var object : Group? {
        willSet {
            guard let data  = newValue else {return}
            self.nameGroupLabel.text = data._name
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

extension EditDeleteGroupTableCell {
    
    @IBAction func editAction(_ sender: UIButton) {
        guard let object = self.object else { return }
        self.delegate?.didTapEditGroup(self, for: object)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let object = self.object else { return }
        self.delegate?.didTapDeleteGroup(self, for: object)
    }
}
