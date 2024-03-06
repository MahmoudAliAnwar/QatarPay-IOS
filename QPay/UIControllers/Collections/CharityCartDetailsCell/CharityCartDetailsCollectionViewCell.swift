//
//  CharityCartDetailsCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol CharityCartDetailsCollectionViewCellDelegate: AnyObject {
    var cellColor: UIColor { get }
    func didTapSelect(with model: CharityDetails, isSelected: Bool)
}

class CharityCartDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemSelectedCheckBox: CheckBox!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var item: CharityDetails? {
        didSet {
            self.itemImageView.image = item?.image
            self.titleLabel.text = item?.title
            self.descriptionLabel.text = item?.desc
            self.amountLabel.text = "QAR \(item?.amount ?? 0.00)"
            self.itemSelectedCheckBox.isChecked = item?.isSelected ?? false
            self.setIsItemSelected(item?.isSelected ?? false)
        }
    }
    
    weak var delegate: CharityCartDetailsCollectionViewCellDelegate! {
        willSet {
            self.amountLabel.textColor = newValue.cellColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.itemSelectedCheckBox.borderStyle = .square
        self.itemSelectedCheckBox.borderWidth = 0
        self.itemSelectedCheckBox.checkmarkColor = .white
        self.itemSelectedCheckBox.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                              action: #selector(self.didTapCheckBox(_:))))
    }
    
    @objc func didTapCheckBox(_ gesture: UITapGestureRecognizer) {
        
        guard let itm = self.item else { return }
        
        self.itemSelectedCheckBox.isChecked.toggle()
        self.setIsItemSelected(self.itemSelectedCheckBox.isChecked)
        self.delegate?.didTapSelect(with: itm, isSelected: self.itemSelectedCheckBox.isChecked)
    }
    
    private func setIsItemSelected(_ selected: Bool) {
        self.itemSelectedCheckBox.backgroundColor = selected ? self.delegate.cellColor : .systemGray3
    }
}
