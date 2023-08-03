//
//  CountryTableViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/11/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setupData(_ country: Country) {
        self.countryName.text = country.name ?? ""
    }
}
