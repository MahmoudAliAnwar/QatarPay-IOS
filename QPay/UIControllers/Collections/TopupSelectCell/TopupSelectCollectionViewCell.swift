//
//  TopupSelectCollectionViewCell.swift
//  QPay
//
//  Created by Dev. Mohmd on 23/11/2020.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol TopupSelectCollectionViewCellDelegate: AnyObject {
    func didSelectAccount(_ card: LibraryCard, isSelected: Bool)
}
class TopupSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var isTopupAccountCheckBox: CheckBox!
    
    weak var delegate: TopupSelectCollectionViewCellDelegate?
    
    var card: LibraryCard! {
        didSet {
            self.ownerNameLabel.text = card.ownerName ?? ""
            self.cardTypeLabel.text = card.cardType ?? ""
            
            guard let num = card.number else { return }
            self.accountNumberLabel.text = self.cardNumberEncrypt(num)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isTopupAccountCheckBox.borderStyle = .square
        self.isTopupAccountCheckBox.style = .tick
        self.isTopupAccountCheckBox.backgroundColor = .systemGray5
        self.isTopupAccountCheckBox.addTarget(self, action: #selector(self.onCheckBoxValueChange(_:)), for: .valueChanged)
    }
    
    @objc func onCheckBoxValueChange(_ checkBox: CheckBox) {
        self.delegate?.didSelectAccount(self.card, isSelected: checkBox.isChecked)
    }
    
    private func cardNumberEncrypt(_ number: String) -> String {
        let last = number.suffix(4)
        return "**** **** **** \(last)"
    }
}
