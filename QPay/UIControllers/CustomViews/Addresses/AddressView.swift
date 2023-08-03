//
//  AddressView.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol AddressViewDelegate: AddressParametersViewDelegate, AddressBoardViewDelegate {
}

class AddressView: UIView {
    
    @IBOutlet weak var addressParametersView: AddressParametersView!
    
    @IBOutlet weak var addressBoardView: AddressBoardView!
    
    var isActionsHidden: Bool! {
        willSet {
            self.addressBoardView.isActionsHidden = newValue
            self.addressParametersView.isActionsHidden = newValue
        }
    }
    
    weak var delegate: AddressViewDelegate? {
        willSet {
            self.addressBoardView.delegate = newValue
            self.addressParametersView.delegate = newValue
        }
    }
    
    var address: Address? {
        willSet {
            self.addressParametersView.address = newValue
            self.addressBoardView.address = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.customInit()
    }
}

// MARK: - CUSTOM FUNCTIONS

extension AddressView {
    
    public func removeViewData() {
        self.addressBoardView.removeData()
        self.addressParametersView.removeData()
    }
    
    private func customInit() {
        guard let view = self.loadViewFromNib() else { return }
        
        self.addSubview(view)
        view.frame = self.bounds
    }
}
