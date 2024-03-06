//
//  AddressCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol AddressParametersViewDesign: AnyObject {
    var defaultButtonHidden: Bool { get }
    var shareButtonImage: UIImage { get }
    var addressNameTextColor: UIColor { get }
    var labelsTextColor: UIColor { get }
}

protocol AddressParametersViewDelegate: AnyObject {
    var parametersDesign: AddressParametersViewDesign { get }
    
    func didTapSetAsDefault(_ view: AddressParametersView, for address: Address)
    func didTapShare(_ view: AddressParametersView, for address: Address)
}

extension AddressParametersViewDelegate {
    func didTapSetAsDefault(_ view: AddressParametersView, for address: Address) {
    }
}

class AddressParametersView: UIView {
    
    @IBOutlet weak var addressNameLabel: UILabel!
    
    @IBOutlet weak var setAsDefaultButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var streetNameLabel: UILabel!
    
    @IBOutlet weak var buildingNumberLabel: UILabel!
    
    @IBOutlet weak var streetNumberLabel: UILabel!
    
    @IBOutlet weak var zoneLabel: UILabel!
    
    weak var delegate: AddressParametersViewDelegate! {
        willSet {
            self.setAsDefaultButton.isHidden = newValue.parametersDesign.defaultButtonHidden
            
            self.shareButton.setImage(newValue.parametersDesign.shareButtonImage, for: .normal)
            
            self.addressNameLabel.textColor = newValue.parametersDesign.addressNameTextColor
            
            [self.streetNameLabel,
             self.buildingNumberLabel,
             self.streetNumberLabel,
             self.zoneLabel].forEach({ $0?.textColor = newValue.parametersDesign.labelsTextColor })
        }
    }
    
    var address: Address? {
        willSet {
            self.addressNameLabel.text = newValue?._name ?? ""
            self.streetNameLabel.text = newValue?._streetName ?? ""
            self.buildingNumberLabel.text = newValue?._buildingNumber ?? ""
            self.zoneLabel.text = "P.O. Box \(newValue?._poBox ?? "")"
            self.streetNumberLabel.text = newValue?._streetNumber ?? ""
        }
    }
    
    var isActionsHidden: Bool! {
        willSet {
            self.setAsDefaultButton.isHidden = newValue.toggleAndReturn()
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

extension AddressParametersView {
    
    public func removeData() {
        self.address = nil
        
        [self.addressNameLabel,
        self.zoneLabel,
        self.streetNameLabel,
        self.buildingNumberLabel,
        self.streetNumberLabel].forEach({ $0?.text?.removeAll() })
    }
    
    private func customInit() {
        guard let view = self.loadViewFromNib() else { return }
        
        self.addSubview(view)
        view.frame = self.bounds
    }
}

// MARK: - ACTIONS

extension AddressParametersView {
    
    @IBAction func setAsDefaultAction(_ sender: UIButton) {
        guard let add = self.address else { return }
        self.delegate.didTapSetAsDefault(self, for: add)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        guard let add = self.address else { return }
        self.delegate.didTapShare(self, for: add)
    }
}
