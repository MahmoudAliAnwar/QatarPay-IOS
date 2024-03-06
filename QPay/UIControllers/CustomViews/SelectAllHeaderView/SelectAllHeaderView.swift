//
//  CharityHeaderView.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol SelectAllHeaderViewDesign: AnyObject {
    var viewColor: UIColor { get }
    
    var checkMarkColor: UIColor { get }
    
    var isHideDeleteButton: Bool { get }
}

extension SelectAllHeaderViewDesign {
    var checkMarkColor: UIColor {
        get {
            return .white
        }
    }
}

protocol SelectAllHeaderViewDelegate: AnyObject {
    var selectAllHeaderViewDesign: SelectAllHeaderViewDesign { get }
    
    func didTapSelectAllCheckBox(with isSelected: Bool)
    func didTapDeleteButton()
}

extension SelectAllHeaderViewDelegate {
    func didTapDeleteButton() {
    }
}

class SelectAllHeaderView: UIView {
    
    @IBOutlet weak var selectAllCheckBox: CheckBox!
    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var trashButton: UIButton!
    
    weak var delegate: SelectAllHeaderViewDelegate! {
        willSet {
            self.trashImageView.tintColor = newValue.selectAllHeaderViewDesign.viewColor
            self.selectAllCheckBox.checkmarkColor = newValue.selectAllHeaderViewDesign.checkMarkColor
            self.hideDeleteAction(newValue.selectAllHeaderViewDesign.isHideDeleteButton)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.customInit()
    }
    
    private func customInit() {
        guard let nib = self.loadViewFromNib() else { return }
        self.addSubview(nib)
        nib.frame = self.bounds
        
        self.setupCheckBox()
    }
    
    private func setupCheckBox() {
        
        self.selectAllCheckBox.borderStyle = .square
        self.selectAllCheckBox.borderWidth = 0
        self.selectAllCheckBox.checkmarkColor = .white
        self.setIsItemSelected(false)
        self.selectAllCheckBox.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didSelectAll(_:)))
        )
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        self.delegate.didTapDeleteButton()
    }
    
    @IBAction func selectAllAction(_ sender: UIButton) {
        self.selectAll()
    }
    
    @objc func didSelectAll(_ gesture: UITapGestureRecognizer) {
        self.selectAll()
    }
    
    private func selectAll() {
        let actionStatus = !self.selectAllCheckBox.isChecked
        self.setIsItemSelected(actionStatus)
        self.delegate.didTapSelectAllCheckBox(with: actionStatus)
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    /// Hide delete feature from view
    private func hideDeleteAction(_ status: Bool) {
        self.trashImageView.isHidden = status
        self.trashButton.isEnabled = !status
    }
    
    public func setIsItemSelected(_ selected: Bool) {
        self.selectAllCheckBox.isChecked = selected
        self.selectAllCheckBox.backgroundColor = selected ? self.delegate.selectAllHeaderViewDesign.viewColor : .white
    }
}
