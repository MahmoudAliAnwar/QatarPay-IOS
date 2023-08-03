//
//  TopUpAccountCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

typealias TopupAccountCellDelegate = CollectionCellSelectDelegate & CollectionCellDeleteDelegate

class TopUpAccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var isDefaultCheckBox: CheckBox!
    @IBOutlet weak var defaultAccountButton: UIButton!
    
    weak var accountCellDelegate: TopupAccountCellDelegate?
    
    var account: Topup! {
        didSet {
            self.accountNameLabel.text = account.ownerName ?? ""
            self.cardNameTextField.text = account.cardName ?? ""
        }
    }
            
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isDefaultCheckBox.style = .tick
        self.isDefaultCheckBox.borderStyle = .square
        self.isDefaultCheckBox.borderWidth = 1
        
        self.isDefaultCheckBox.addTarget(self, action: #selector(onCheckBoxValueChange(_:)), for: .valueChanged)
    }

    @IBAction func deleteAction(_ sender: UIButton) {
        if let id = self.account.id {
            self.accountCellDelegate?.onCellDeleted(self, id: id)
        }
    }
    
    @IBAction func setAccountDefaultAction(_ sender: UIButton) {
        
//        self.isDefaultCheckBox.isChecked = !self.isDefaultCheckBox.isChecked
        self.changeCheckBoxStatus()
    }
    
    @objc func onCheckBoxValueChange(_ sender: CheckBox) {
        
//        self.isDefaultCheckBox.isChecked = !sender.isChecked
        self.changeCheckBoxStatus()
    }
    
    private func changeCheckBoxStatus() {
        self.accountCellDelegate?.onCellSelected(self, object: self.account as Any)
    }
    
    public func setDefaultCellButton(_ status: Bool) {
        self.defaultAccountButton.setTitle(status ? "Default Topup Account" : "Set as Default", for: .normal)
        self.defaultAccountButton.setTitleColor(status ? .mDark_Red : .mDark_Gray, for: .normal)
        self.isDefaultCheckBox.isChecked = status
    }
}
