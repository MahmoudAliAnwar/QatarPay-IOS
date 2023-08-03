//
//  MarketDateSpreadViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit
import SpreadsheetView

class MarketDateSpreadViewCell: Cell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    var text: String = "" {
        willSet {
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.text = newValue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.backgroundColor = .clear
//        self.titleLabel.textColor = Configuration.default.textColor
//        self.titleLabel.font = Configuration.default.textFont
    }
    
    var configuration: Configuration = .default {
        didSet {
            self.changeConfiguration()
        }
    }
    
    struct Configuration {
        var textColor: UIColor
        var textFont: UIFont?
        
        static let `default`: Self = .init(textColor: .black,
                                           textFont: UIFont.sfDisplay(12)
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = self.contentView.bounds
    }
    
    func changeConfiguration() {
        self.titleLabel.textColor = self.configuration.textColor
        self.titleLabel.font = self.configuration.textFont
    }
}
