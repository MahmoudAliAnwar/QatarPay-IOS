//
//  InvoiceCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol InvoiceCollectionViewCellDelegate: AnyObject {
    func didTapArchive(order: Order)
}

class InvoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var archiveView: UIView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusViewDesign: ViewDesign!
    @IBOutlet weak var totalContainerView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    weak var delegate: InvoiceCollectionViewCellDelegate?
    
    var isArchiveOrder: Bool = false
    
    var order: Order! {
        willSet {
            if let status = newValue.paymentStatusID {
                self.setCellStatusTo(status)
            }
            
            if let number = newValue.orderNumber {
                self.numberLabel.text = number
            }
            
            if let customer = newValue.customerName {
                self.customerLabel.text = customer
            }
            
            if let total = newValue.orderTotal {
                self.totalLabel.text = "QAR \(total.description)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.totalContainerView.layer.borderWidth = 1.0
        self.totalContainerView.layer.cornerRadius = self.totalContainerView.frame.height / 2
        self.statusViewDesign.setViewCorners([.topRight, .bottomRight])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let status = self.order.paymentStatusID {
            self.setCellStatusTo(status)
        }
    }
    
    @IBAction func archiveOrderAction(_ sender: UIButton) {
        self.delegate?.didTapArchive(order: self.order)
    }
    
    private func setCellStatusTo(_ status: Int) {
        
        var color: UIColor = .systemGreen
        
        guard let invoiceStatus = InvoicePaidStatus(rawValue: status) else { return }
        
        self.isHideArchiveView(invoiceStatus == .Pending ||
                                invoiceStatus == .Failed ||
                                self.isArchiveOrder
        )
        
        switch invoiceStatus {
        case .Online:
            self.setupCellStyle(color, image: Images.ic_money_invoices.image)
            
        case .Pending, .Failed:
            color = .systemOrange
            self.setupCellStyle(color, image: Images.ic_sand_clock_invoices.image)
            
        case .Cash:
//            color = .systemRed
            self.setupCellStyle(color, image: Images.ic_money_invoices.image)
        }
    }
    
    private func setupCellStyle(_ color: UIColor, image: UIImage) {
        
        self.statusViewDesign.backgroundColor = color
        self.statusImageView.image = image
        self.totalContainerView.layer.borderColor = color.cgColor
        self.totalLabel.textColor = color
    }
    
    private func isHideArchiveView(_ status: Bool) {
        self.archiveView.isHidden = status
    }
}
