//
//  UITextFieldExtension.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

//@IBDesignable
class TextFieldDesign: UITextField {
    
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return .clear
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
