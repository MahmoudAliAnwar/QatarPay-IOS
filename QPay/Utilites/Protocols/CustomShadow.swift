//
//  CustomShadow.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol CustomShadow: AnyObject {
    var color: UIColor { get }
    var opacity: Float { get }
    var radius: CGFloat { get }
    var offset: CGSize { get }
}
