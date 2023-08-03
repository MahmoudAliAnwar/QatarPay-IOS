//
//  ServiceCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var serviceCounterViewDesign: ViewDesign!
    @IBOutlet weak var serviceCounterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.serviceImageView.image = .none
    }

    public func setupData(_ service: Service) {
        
        if let imageLocation = service.location, let name = service.name {
            
            imageLocation.getImageFromURLString { (status, image) in
                if status {
                    if let img = image {
                        self.serviceImageView.image = img
                    }
                }
            }
            
            self.serviceNameLabel.text = name
        }
    }
}
