//
//  ExpandableCollectionViewCell.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import UIKit

protocol ExpandableCollectionViewCellDesign: AnyObject {
    func isSectionTotalHidden(for type: ExpandableCollectionViewCell.CellType) -> Bool
    func isCheckBoxHidden(for type: ExpandableCollectionViewCell.CellType) -> Bool
    func sectionTotalFont(for type: ExpandableCollectionViewCell.CellType) -> UIFont?
}

extension ExpandableCollectionViewCellDesign {
    
    func isCheckBoxHidden(for type: ExpandableCollectionViewCell.CellType) -> Bool {
        return false
    }
}

protocol ExpandableCollectionViewCellDelegate: AnyObject {
    var cellColor: UIColor { get }
    
    func didTapCheckBox(_ cell: ExpandableCollectionViewCell,
                        isSelected: Bool,
                        cellType: ExpandableCollectionViewCell.CellType,
                        at indexPath: IndexPath
    )
}

class ExpandableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var subContainerStackView: UIStackView!
    @IBOutlet weak var containerViewDesign: ViewDesign!
    
    @IBOutlet weak var checkboxStackView: UIStackView!
    
    @IBOutlet weak var topSeperatorView: UIView!
    
    @IBOutlet weak var leftStyleTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftStyleBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftStyleViewDesign: ViewDesign!
    
    @IBOutlet weak var selectCheckBox: CheckBox!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ExpandableCollectionViewCellDelegate!
    
    var cellType: CellType?
    
    var isCellSelected: Bool = false {
        willSet {
            self.setIsItemSelected(newValue)
        }
    }
    
    enum CellType {
        case Section(isOpened: Bool)
        case Row(isLastRow: Bool)
    }
    
    var isShowTopSeperator: Bool = false {
        willSet {
            self.topSeperatorView.isHidden = !newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupCheckBox()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.containerViewDesign.cornerRadius = 0
        self.leftStyleViewDesign.cornerRadius = 0
        self.setLeftViewDesignPadding(top: 0, bottom: 0)
        self.setCellShodow(color: .clear,
                           opacity: 0,
                           radius: 0,
                           offset: CGSize(width: 0, height: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func setupCell(to type: CellType, with design: ExpandableCollectionViewCellDesign) {
        self.cellType = type
        
        self.totalLabel.isHidden = design.isSectionTotalHidden(for: type)
        self.checkboxStackView.isHidden = design.isCheckBoxHidden(for: type)
        self.totalLabel.font = design.sectionTotalFont(for: type)
        
        let leftStyleViewPadding: CGFloat = self.height / 5
        let containerViewCorner: CGFloat = 0
        
        let cellPadding: CGFloat = 14
        let cellBottomPadding: CGFloat = 12
        
        let subStackViewLeftPadding: CGFloat = cellPadding
        
        self.setCellShodow(color: .clear,
                           opacity: 0,
                           radius: 0,
                           offset: CGSize(width: 0, height: 0))
        
        switch type {
        case .Section(let isOpened):
            self.iconImageView.image = isOpened ? .ic_arrow_down_gray : .ic_arrow_right_kahramaa
            
            self.containerViewDesign.cornerRadius = containerViewCorner
            self.setContainerStackLayoutMargin(insets: UIEdgeInsets(top: 0,
                                                             left: cellPadding,
                                                             bottom: isOpened ? 0 : cellBottomPadding,
                                                             right: cellPadding))
            self.subContainerStackView.layoutMargins = UIEdgeInsets(top: 0,
                                                             left: subStackViewLeftPadding,
                                                             bottom: 0,
                                                             right: cellPadding)
            
            self.setLeftViewDesignPadding(top: leftStyleViewPadding,
                                          bottom: isOpened ? 0 : leftStyleViewPadding)
            
            if isOpened {
                self.setLeftViewDesignCorner(.topRight)
                self.containerViewDesign.setViewCorners([.topLeft, .topRight])
                
            }else {
                self.setLeftViewDesignCorner([.topRight, .bottomRight])
                self.containerViewDesign.setViewCorners(.allCorners)
                
                self.setCellShodow()
            }
            
            break
            
        case .Row(let isLastRow):
            self.iconImageView.image = .ic_arrow_right_kahramaa
            
            self.containerStackView.layoutMargins.bottom = 0
            self.setContainerStackLayoutMargin(insets: UIEdgeInsets(top: 0,
                                                             left: cellPadding,
                                                             bottom: isLastRow ? cellBottomPadding : 0,
                                                             right: cellPadding))
            self.setSubContainerStackLayoutMargin(insets: UIEdgeInsets(top: 0,
                                                                left: subStackViewLeftPadding*2,
                                                                bottom: 0,
                                                                right: cellPadding))
            
            self.containerViewDesign.cornerRadius = 0
            self.setLeftViewDesignPadding(top: 0,
                                          bottom: 0)
            
            if isLastRow {
                self.containerViewDesign.setViewCorners([.bottomLeft, .bottomRight])
                self.containerViewDesign.cornerRadius = containerViewCorner
                self.setLeftViewDesignCorner(.bottomRight)
                self.setLeftViewDesignPadding(top: 0,
                                              bottom: leftStyleViewPadding)
                
                self.setCellShodow()
            }
            
            break
        }
    }
    
    public func changeLeftViewDesignBackgroundColor(_ color: UIColor) {
        self.leftStyleViewDesign.backgroundColor = color
    }
    
    private func setLeftViewDesignCorner(_ corners: UIRectCorner) {
        self.leftStyleViewDesign.cornerRadius = self.leftStyleViewDesign.width / 2
        self.leftStyleViewDesign.setViewCorners(corners)
    }
    
    private func setCellShodow(color: UIColor = .lightGray,
                               opacity: Float = 0.2,
                               radius: CGFloat = 6,
                               offset: CGSize = CGSize(width: 0, height: 5)) {
        
        self.containerViewDesign.shadowColor = color
        self.containerViewDesign.shadowOpacity = opacity
        self.containerViewDesign.shadowRadius = radius
        self.containerViewDesign.shadowOffset = CGSize(width: 0, height: 6)
    }
    
    private func setContainerStackLayoutMargin(insets: UIEdgeInsets) {
        self.containerStackView.isLayoutMarginsRelativeArrangement = true
        self.containerStackView.layoutMargins = insets
    }
    
    private func setSubContainerStackLayoutMargin(insets: UIEdgeInsets) {
        self.subContainerStackView.isLayoutMarginsRelativeArrangement = true
        self.subContainerStackView.layoutMargins = insets
    }
    
    private func setLeftViewDesignPadding(top: CGFloat, bottom: CGFloat) {
        self.leftStyleTopLayoutConstraint.constant = top
        self.leftStyleBottomLayoutConstraint.constant = bottom
    }
    
    private func setupCheckBox() {
        self.selectCheckBox.borderStyle = .square
        self.selectCheckBox.checkmarkColor = .white
        self.selectCheckBox.borderWidth = 0
        self.selectCheckBox.backgroundColor = .systemGray6
        self.selectCheckBox.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didTapCheckBox(_:)))
        )
    }
    
    private func setIsItemSelected(_ selected: Bool) {
        self.selectCheckBox.isChecked = selected
        self.selectCheckBox.backgroundColor = selected ? self.delegate.cellColor : .systemGray6
    }
}

// MARK: - ACTIONS

extension ExpandableCollectionViewCell {
    
    @objc func didTapCheckBox(_ gesture: UITapGestureRecognizer) {
        guard let type = self.cellType,
              let indexPath = self.indexPath else {
            return
        }
        self.delegate?.didTapCheckBox(self, isSelected: !self.selectCheckBox.isChecked, cellType: type, at: indexPath)
    }
}
