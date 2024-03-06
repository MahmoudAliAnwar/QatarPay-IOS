//
//  CustomProgress.swift
//  ZakariaApp01
//
//  Created by Dev. Mohmd on 11/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class CustomProgress: UIProgressView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskLayerPath.cgPath
        layer.mask = maskLayer
    }
}
