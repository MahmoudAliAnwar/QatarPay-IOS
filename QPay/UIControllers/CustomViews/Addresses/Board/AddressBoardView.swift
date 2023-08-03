//
//  AddressBoardView.swift
//  QPay
//
//  Created by Mohammed Hamad on 05/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol AddressBoardViewDesign: AnyObject {
    var borderColor: UIColor { get }
    var deleteIconColor: UIColor { get }
    var editIconColor: UIColor { get }
    
    var borderWidth: CGFloat { get }
    var fieldsFontSize: CGFloat { get }
    var enLabelsFontSize: CGFloat { get }
    var arLabelsFontSize: CGFloat { get }
    
    var isFieldsEnabled: Bool { get }
    var isActionsHidden: Bool { get }
}

protocol AddressBoardViewDelegate {
    var boardDesign: AddressBoardViewDesign { get }
    
    func didTapDelete(_ view: AddressBoardView, for: Address)
    func didTapEdit(_ view: AddressBoardView, for: Address)
}

extension AddressBoardViewDelegate {
    func didTapDelete(_ view: AddressBoardView, for: Address) {
    }
    
    func didTapEdit(_ view: AddressBoardView, for: Address) {
    }
}

class AddressBoardView: UIView {
    
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var actionsStackView: UIStackView!
    
    @IBOutlet weak var deleteImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var editImageViewDesign: ImageViewDesign!
    
    @IBOutlet weak var horizontalViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var verticalViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var buildingNumberENLabel: UILabel!

    @IBOutlet weak var buildingNumberARLabel: UILabel!
    
    @IBOutlet weak var zoneENLabel: UILabel!

    @IBOutlet weak var zoneARLabel: UILabel!

    @IBOutlet weak var streetNumberENLabel: UILabel!

    @IBOutlet weak var streetNumberARLabel: UILabel!
    
    @IBOutlet weak var buildingNumberStackView: UIStackView!
    
    @IBOutlet weak var buildingNumberTextField: UITextField!

    @IBOutlet weak var zoneStackView: UIStackView!
    
    @IBOutlet weak var zoneTextField: UITextField!
    
    @IBOutlet weak var streetNumberStackView: UIStackView!

    @IBOutlet weak var streetNumberTextField: UITextField!
    
    var delegate: AddressBoardViewDelegate! {
        willSet {
            let borderWidth = newValue.boardDesign.borderWidth
            
            self.containerViewDesign.borderColor = newValue.boardDesign.borderColor
            self.containerViewDesign.borderWidth = borderWidth
            
            let padding = borderWidth * 2
            
            self.buildingNumberStackView.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            self.zoneStackView.layoutMargins = UIEdgeInsets(top: 4, left: padding, bottom: 0, right: borderWidth)
            self.streetNumberStackView.layoutMargins = UIEdgeInsets(top: 4, left: borderWidth, bottom: 0, right: padding)
            
            self.deleteImageViewDesign.imageTintColor = newValue.boardDesign.deleteIconColor
            self.editImageViewDesign.imageTintColor = newValue.boardDesign.editIconColor
            
            let fieldsFont = R.font.sfuiDisplayMedium(size: newValue.boardDesign.fieldsFontSize)
            let arlabelsFont = R.font.theSansBoldPlain(size: newValue.boardDesign.arLabelsFontSize)
            let enlabelsFont = R.font.gothamMedium(size: newValue.boardDesign.enLabelsFontSize)
            
            let minimumFieldsFontSize = newValue.boardDesign.fieldsFontSize-5
            let minimumLabelsScaleFactor: CGFloat = 0.5
            
            self.buildingNumberENLabel.font = enlabelsFont
            self.buildingNumberENLabel.minimumScaleFactor = minimumLabelsScaleFactor
            self.zoneENLabel.font = enlabelsFont
            self.zoneENLabel.minimumScaleFactor = minimumLabelsScaleFactor
            self.streetNumberENLabel.font = enlabelsFont
            self.streetNumberENLabel.minimumScaleFactor = minimumLabelsScaleFactor
            
            self.buildingNumberARLabel.font = arlabelsFont
            self.buildingNumberARLabel.minimumScaleFactor = minimumLabelsScaleFactor
            self.zoneARLabel.font = arlabelsFont
            self.zoneARLabel.minimumScaleFactor = minimumLabelsScaleFactor
            self.streetNumberARLabel.font = arlabelsFont
            self.streetNumberARLabel.minimumScaleFactor = minimumLabelsScaleFactor
            
            self.zoneTextField.font = fieldsFont
            self.zoneTextField.minimumFontSize = minimumFieldsFontSize
            self.streetNumberTextField.font = fieldsFont
            self.streetNumberTextField.minimumFontSize = minimumFieldsFontSize
            self.buildingNumberTextField.font = fieldsFont
            self.buildingNumberTextField.minimumFontSize = minimumFieldsFontSize
            
            self.horizontalViewHeight.constant = newValue.boardDesign.borderWidth
            self.verticalViewWidth.constant = newValue.boardDesign.borderWidth
            
            self.actionsStackView.isHidden = newValue.boardDesign.isActionsHidden
            
            [self.zoneTextField,
             self.buildingNumberTextField,
             self.streetNumberTextField].forEach({ $0?.isEnabled = newValue.boardDesign.isFieldsEnabled })
        }
    }
    
    var address: Address? {
        willSet {
            self.buildingNumberTextField.text = newValue?._buildingNumber ?? ""
            self.zoneTextField.text = newValue?._zone ?? ""
            self.streetNumberTextField.text = newValue?._streetNumber ?? ""
        }
    }
    
    var isActionsHidden: Bool! {
        willSet {
            self.actionsStackView.isHidden = newValue
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

extension AddressBoardView {
    
    public func removeData() {
        self.address = nil
        
        self.zoneTextField.text?.removeAll()
        self.streetNumberTextField.text?.removeAll()
        self.buildingNumberTextField.text?.removeAll()
    }
    
    private func customInit() {
        guard let view = self.loadViewFromNib() else { return }
        
        self.addSubview(view)
        view.frame = self.bounds
    
        self.containerViewDesign.cornerRadius = (self.containerViewDesign.height / 20)
    }
}

// MARK: - ACTIONS

extension AddressBoardView {
    
    @IBAction func deleteAction(_ sender: UIButton) {
        guard let add = self.address else { return }
        self.delegate.didTapDelete(self, for: add)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        guard let add = self.address else { return }
        self.delegate.didTapEdit(self, for: add)
    }
}

