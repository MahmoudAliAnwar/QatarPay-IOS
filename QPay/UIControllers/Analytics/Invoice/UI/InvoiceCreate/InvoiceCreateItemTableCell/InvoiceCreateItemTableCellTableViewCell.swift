//
//  InvoiceCreateItemTableCellTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol InvoiceCreateItemTableCellTableViewCellDelegate: AnyObject {
    func didTapAdd(_ cell: InvoiceCreateItemTableCellTableViewCell, after index: Int)
    func didEndEditing(_ cell: InvoiceCreateItemTableCellTableViewCell, for item: CreateInvoiceModel.Item, at indexPath: IndexPath)
}

class InvoiceCreateItemTableCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemDescriptionTextField: UITextField!
    
    @IBOutlet weak var itemQuantityTextField: UITextField!
    
    @IBOutlet weak var itemRateTextField: UITextField!
    
    @IBOutlet weak var itemAmountTextField: UITextField!
    
    var object: CreateInvoiceModel.Item! {
        willSet {
            self.itemDescriptionTextField.text = newValue.description
            self.itemQuantityTextField.text = newValue.quantity == 0 ? "" : "\(newValue.quantity)"
            self.itemRateTextField.text = newValue.rate == 0 ? "" : "\(newValue.rate)"
            self.itemAmountTextField.text = newValue.amount == 0 ? "" : "\(newValue.amount)"
        }
    }
    
    weak var delegate: InvoiceCreateItemTableCellTableViewCellDelegate?
    
    private var quantity: Double?
    private var rate: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.itemDescriptionTextField.delegate = self
        self.itemQuantityTextField.delegate = self
        self.itemRateTextField.delegate = self
        self.itemAmountTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
}

// MARK: - ACTIONS

extension InvoiceCreateItemTableCellTableViewCell {
    
    @IBAction func addAction(_ sender: UIButton) {
        guard let index = self.indexPath else { return }
        self.delegate?.didTapAdd(self, after: index.row)
    }
}

// MARK: - TEXT FIELD DELEGATE

extension InvoiceCreateItemTableCellTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let index = self.indexPath else { return }
        guard let text = textField.text else {
            return
        }
        
        if textField == self.itemDescriptionTextField {
            self.object.description = text
            
        } else if textField == self.itemQuantityTextField {
            guard let qty = Double(text) else { return }
            self.quantity = qty
            self.object.quantity = qty
            self.setAmountToField()
            
        } else if textField == self.itemRateTextField {
            guard let rate = Double(text) else { return }
            self.rate = rate
            self.object.rate = rate
            self.setAmountToField()
        }
        
        self.delegate?.didEndEditing(self, for: self.object, at: index)
    }
}

// MARK: - CUSTOM FUNCTIONS

extension InvoiceCreateItemTableCellTableViewCell {
    
    func calcAmount() -> Double {
        guard let qty = self.quantity,
              let rate = self.rate else {
            return 0
        }
        return qty * rate
    }
    
    private func setAmountToField() {
        self.itemAmountTextField.text = "\(self.calcAmount())"
        self.object.amount = self.calcAmount()
    }
}
