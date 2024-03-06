//
//  AddressTableViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol AddressTableViewCellDelegate: AnyObject {
    func didTapSetAsDefault(_ cell: AddressTableViewCell, for address: Address)
    func didTapShare(_ cell: AddressTableViewCell, for address: Address)
    func didTapDelete(_ cell: AddressTableViewCell, for address: Address)
    func didTapEdit(_ cell: AddressTableViewCell, for address: Address)
}

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressView: AddressView!

    var delegate: AddressTableViewCellDelegate?
    
    var address: Address! {
        willSet {
            self.addressView.address = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addressView.delegate = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - ADRESS VIEW DELEGATE

extension AddressTableViewCell: AddressViewDelegate {
    
    var boardDelegate: AddressBoardViewDelegate {
        get {
            return self
        }
    }
    
    var parametersDelegate: AddressParametersViewDelegate {
        get {
            return self
        }
    }
}

// MARK: - ADRESS BOARD VIEW DELEGATE

extension AddressTableViewCell: AddressBoardViewDelegate {
    
    var boardDesign: AddressBoardViewDesign {
        get {
            return CellBoardDesign()
        }
    }
    
    func didTapDelete(_ view: AddressBoardView, for: Address) {
        self.delegate?.didTapDelete(self, for: address)
    }
    
    func didTapEdit(_ view: AddressBoardView, for: Address) {
        self.delegate?.didTapEdit(self, for: address)
    }
}

// MARK: - ADRESS PARAMETERS VIEW DELEGATE

extension AddressTableViewCell: AddressParametersViewDelegate {
    
    func didTapSetAsDefault(_ view: AddressParametersView, for address: Address) {
        self.delegate?.didTapSetAsDefault(self, for: address)
    }
    
    func didTapShare(_ view: AddressParametersView, for address: Address) {
        self.delegate?.didTapShare(self, for: address)
    }
    
    var parametersDesign: AddressParametersViewDesign {
        get {
            return CellParametersDesign()
        }
    }
}

// MARK: - PARAMETERS DESIGN CLASS

class CellParametersDesign: AddressParametersViewDesign {
    
    var shareButtonImage: UIImage {
        get {
            R.image.ic_share_my_shops() ?? UIImage()
        }
    }
    
    var defaultButtonHidden: Bool {
        get {
            return false
        }
    }
    
    var addressNameTextColor: UIColor {
        get {
            return .systemBlue
        }
    }
    
    var labelsTextColor: UIColor {
        get {
            return .mLabel_Dark_Gray
        }
    }
}

// MARK: - BOARD DESIGN CLASS

class CellBoardDesign: AddressBoardViewDesign {
    
    var deleteIconColor: UIColor {
        get {
            return .appBackgroundColor
        }
    }
    
    var editIconColor: UIColor {
        get {
            return .appBackgroundColor
        }
    }
    
    var isActionsHidden: Bool {
        get {
            return true
        }
    }
    
    var borderColor: UIColor {
        get {
            return .systemGray5
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return 5
        }
    }
    
    var fieldsFontSize: CGFloat {
        get {
            return 14
        }
    }
    
    var arLabelsFontSize: CGFloat {
        get {
            return 9
        }
    }
    
    var enLabelsFontSize: CGFloat {
        get {
            return 6
        }
    }
    
    var isFieldsEnabled: Bool {
        get {
            return false
        }
    }
}
