//
//  CustomDropDown.swift
//  QPay
//
//  Created by Mohammed Hamad on 25/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import DropDown

protocol CustomDropDownAppearance: AnyObject {
    var backgroundColor: UIColor { get }
    var selectionBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var cornerRadius: CGFloat { get }
    
    var shadow: CustomShadow? { get }
    
    var animationDuration: Double { get }
    var textColor: UIColor { get }
}

protocol CustomDropDownDataSource: AnyObject {
    func numberOfSections(in customDropDown: CustomDropDown) -> Int
    func customDropDown(_ customDropDown: CustomDropDown, numberOfRowsInSection section: Int) -> [String]
}

extension CustomDropDownDataSource {
    func numberOfSections(in customDropDown: CustomDropDown) -> Int {
        return 1
    }
}

protocol CustomDropDownDelegate: AnyObject {
    var containerBackgroundColor: UIColor { get }
    var textLabelColor: UIColor { get }
    var containerBorderWidth: CGFloat { get }
    var containerBorderColor: UIColor { get }
    var isContainerCircleCorner: Bool { get }
    var placeholder: String? { get }
    
    var direction: CustomDropDown.Direction { get }
    var dismissMode: CustomDropDown.DismissMode { get }
    
    func customDropDown(appearance customDropDown: CustomDropDown) -> CustomDropDownAppearance
    
    func didSelect(_ customDropDown: CustomDropDown, item: String, with index: Int)
}

extension CustomDropDownDelegate {
    
    var placeholder: String? {
        get {
            "select..."
        }
    }
    
    var shadow: CustomShadow {
        get {
            DefaulCustomShadow()
        }
    }
}

final class CustomDropDown: ViewDesign {
    
    @IBOutlet weak var dropDownContainerViewDesign: ViewDesign!
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var dropDownErrorImageView: UIImageView!
    @IBOutlet weak var dropDownArrowIcon: UIImageView!
    
    private let dropDown = DropDown()
    
    private var items: [String] = [] {
        willSet {
            self.dropDown.dataSource = newValue
        }
    }
    
    var item: String? {
        willSet {
            self.dropDownLabel.text = newValue
            self.dropDownLabel.textColor = .black
        }
    }
    
    var placehoder: String? {
        willSet {
            self.dropDownLabel.text = newValue
            self.dropDownLabel.textColor = .systemGray5
        }
    }
    
    var error: Bool = false {
        willSet {
            self.dropDownErrorImageView.image = newValue ? .errorCircle : .none
        }
    }
    
    weak var dataSource: CustomDropDownDataSource? {
        willSet {
            guard let dataSource = newValue else { return }
            let sections = dataSource.numberOfSections(in: self)

            for i in 0..<sections {
                let rows = dataSource.customDropDown(self, numberOfRowsInSection: i)
                self.items = rows
            }
        }
    }
    
    weak var delegate: CustomDropDownDelegate? {
        willSet {
            guard let delegate = newValue else { return }
            self.dropDown.anchorView = self

            self.shadowRadius = delegate.shadow.radius
            self.shadowOpacity = delegate.shadow.opacity
            self.shadowColor = delegate.shadow.color
            self.shadowOffset = delegate.shadow.offset
            
            self.placehoder = delegate.placeholder
            self.dropDownLabel.textColor = delegate.textLabelColor
            self.dropDownContainerViewDesign.backgroundColor = delegate.containerBackgroundColor
            self.dropDownContainerViewDesign.borderWidth = delegate.containerBorderWidth
            self.dropDownContainerViewDesign.borderColor = delegate.containerBorderColor
            self.dropDownContainerViewDesign.isCircle = delegate.isContainerCircleCorner
            
            self.dropDown.topOffset = CGPoint(x: 0, y: self.bounds.height)
            
            switch delegate.direction {
            case .any: self.dropDown.direction = .any
            case .top: self.dropDown.direction = .top
            case .bottom: self.dropDown.direction = .bottom
            }
            
            switch delegate.dismissMode {
            case .automatic: self.dropDown.dismissMode = .automatic
            case .manual: self.dropDown.dismissMode = .manual
            case .onTap: self.dropDown.dismissMode = .onTap
            }
            
            self.configureAppearance(delegate.customDropDown(appearance: self))
        }
    }
    
    enum Direction {
        case any
        case top
        case bottom
    }
    
    enum DismissMode {
        case automatic
        case manual
        case onTap
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    public func setupView() {
        guard let view = self.loadViewFromNib() else { return }
        
        self.addSubview(view)
        view.frame = self.bounds
        
        self.dropDown.selectionAction = { [weak self] (index, item) in
            guard let mySelf = self else { return }
            mySelf.item = item
            mySelf.delegate?.didSelect(mySelf, item: item, with: index)
        }
    }
    
    private func configureAppearance(_ dropDownAppearance: CustomDropDownAppearance) {
        let appearance = DropDown.appearance()
        appearance.cellHeight = self.height
        appearance.cornerRadius = dropDownAppearance.cornerRadius
        appearance.animationduration = dropDownAppearance.animationDuration
        
        if let shadow = dropDownAppearance.shadow {
            appearance.shadowOpacity = shadow.opacity
            appearance.shadowRadius = shadow.radius
            appearance.shadowColor = shadow.color
            appearance.shadowOffset = shadow.offset
        }
        
        appearance.backgroundColor = dropDownAppearance.backgroundColor
        appearance.separatorColor = dropDownAppearance.separatorColor
        appearance.selectionBackgroundColor = dropDownAppearance.selectionBackgroundColor
        appearance.textColor = dropDownAppearance.textColor
    }
}

extension CustomDropDown {
    
    @IBAction func showAction(_ sender: UIButton) {
        self.dropDown.show()
    }
}

// MARK: - Default Classes...

class DefaultCustomDropDownAppearance: CustomDropDownAppearance {
    
    var backgroundColor: UIColor {
        get {
            .white
        }
    }
    
    var selectionBackgroundColor: UIColor {
        get {
            UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        }
    }
    
    var separatorColor: UIColor {
        get{
            UIColor(white: 0.7, alpha: 0.8)
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            10
        }
    }
    
    var shadow: CustomShadow? {
        get {
            DefaulCustomShadow()
        }
    }
    
    var animationDuration: Double {
        get {
            0.25
        }
    }
    
    var textColor: UIColor {
        get {
            appBackgroundColor
        }
    }
}

class DefaulCustomShadow: CustomShadow {
    
    var color: UIColor {
        get {
            .darkGray
        }
    }
    
    var opacity: Float {
        get {
            0.3
        }
    }
    
    var radius: CGFloat {
        get {
            4
        }
    }
    
    var offset: CGSize {
        get {
            CGSize(width: 0, height: 5)
        }
    }
}
