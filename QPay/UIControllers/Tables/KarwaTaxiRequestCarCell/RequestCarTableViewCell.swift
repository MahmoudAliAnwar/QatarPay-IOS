//
//  RequestCarTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

class RequestCarTableViewCell: UITableViewCell {
    static let identifier = "RequestCarTableViewCell"
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carPassengersQuantityLabel: UILabel!
    @IBOutlet weak var carAmountLabel: UILabel!
    @IBOutlet weak var carTimeLabel: UILabel!

    var car: KarwaTaxiCar! {
        didSet {
            self.carImageView.image = car._image
            
            self.carNameLabel.text = car._name
            self.carPassengersQuantityLabel.text = car._passengers
            self.carAmountLabel.text = car._amount
            self.carTimeLabel.text = car._time
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
