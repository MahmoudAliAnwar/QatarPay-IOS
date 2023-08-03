//
//  FloatingPanelControllerExtension.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/02/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import FloatingPanel

extension FloatingPanelController {
    
    func setAppearanceForPhone(_ corner: CGFloat) {
        let appearance = SurfaceAppearance()
        if #available(iOS 13.0, *) {
            appearance.cornerCurve = .continuous
        }
        appearance.cornerRadius = corner
        appearance.backgroundColor = .clear
        surfaceView.appearance = appearance
    }
}
