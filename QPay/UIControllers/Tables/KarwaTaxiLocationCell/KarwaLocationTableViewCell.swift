//
//  KarwaLocationTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 06/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol KarwaLocationTableViewCellDelegate: AnyObject {
    func didTapMenuButton(_ location: KarwaLocation)
}

class KarwaLocationTableViewCell: UITableViewCell {
    static let identifier = "KarwaLocationTableViewCell"
    
    @IBOutlet weak var locationNameLabel: UILabel!

    var location: KarwaLocation! {
        didSet {
            self.locationNameLabel.text = location.name
        }
    }
    
    weak var delegate: KarwaLocationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        self.delegate?.didTapMenuButton(self.location!)
    }
}
