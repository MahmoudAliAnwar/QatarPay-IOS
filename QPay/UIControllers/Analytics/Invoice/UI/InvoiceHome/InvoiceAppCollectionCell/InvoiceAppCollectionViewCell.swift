//
//  InvoiceAppCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 03/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

class InvoiceAppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusViewDesign: ViewDesign!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var object: InvoiceApp! {
        willSet {
            self.numberLabel.text = newValue._number
            self.nameLabel.text = newValue._recipitantName
            self.amountLabel.text = "QAR \(newValue._amount)"
            self.companyLabel.text = newValue._company
            
            if let date = newValue._date.formatToDate(.Server2) {
                self.dueDateLabel.text = "Due \(date.formatDate("dd/MM/yyyy"))"
            }
            
            guard let status = newValue._statusObject else { return }
            self.statusLabel.text = status.rawValue
            self.statusViewDesign.backgroundColor = status.color
            
            switch status {
            case .success:
                break
            case .pending:
                break
            case .failed:
                break
            case .void:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
