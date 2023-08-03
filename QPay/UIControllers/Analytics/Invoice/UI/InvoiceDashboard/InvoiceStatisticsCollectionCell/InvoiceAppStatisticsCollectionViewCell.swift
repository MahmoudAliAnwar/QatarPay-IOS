//
//  InvoiceAppStatisticsCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceAppStatisticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerGradientView: GradientView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    var object: InvoiceStatistics! {
        willSet {
//            self.titleLabel.text = newValue._name
            self.valueLabel.text = "\(newValue._value)"
            
            guard let gradient = newValue._type?.gradientView else { return }
            self.containerGradientView.startColor = gradient.startColor
            self.containerGradientView.endColor = gradient.endColor
            self.containerGradientView.alpha = 0.7
            
//            self.containerGradientView.shadowColor = gradient.startColor
//            self.containerGradientView.shadowRadius = 4
//            self.containerGradientView.shadowOpacity = 0.2
//            self.containerGradientView.shadowOffset = CGSize(width: 0, height: 3)
//            self.containerGradientView.clipsToBounds = false
//            self.containerGradientView.layer.masksToBounds = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerGradientView.cornerRadius = self.containerGradientView.width / 8
    }
}
