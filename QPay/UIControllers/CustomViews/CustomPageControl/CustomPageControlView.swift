//
//  CustomPageControlView.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class CustomPageControlView: UIView {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var innerStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.innerView.backgroundColor = .appBackgroundColor
        self.innerView.clipsToBounds = true
        
        self.outerView.clipsToBounds = true
        self.outerView.layer.borderWidth = 1.5
        self.outerView.layer.borderColor = UIColor.clear.cgColor
        self.outerView.backgroundColor = .clear
        
        let padding: CGFloat = self.height/5
        self.innerStackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    private func setupView() {
        
        let bundle = Bundle.main.loadNibNamed("CustomPageControlView", owner: self, options: nil)
        if let nibView = bundle?.first as? UIView {
            nibView.frame = self.bounds
            self.addSubview(nibView)
        }
    }
}
