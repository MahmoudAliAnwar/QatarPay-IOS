//
//  SnackBarBuilder.swift
//  ScanQR
//
//  Created by Mohammed Hamad on 20/07/2021.
//

import Foundation
import UIKit
import TTGSnackbar

class SnackbarBuilder {
    
    var snack: TTGSnackbar
    
    public static func getInstance(_ message: String, duration: TTGSnackbarDuration = .middle) -> SnackbarBuilder {
        return SnackbarBuilder(message, duration: duration)
    }
    
    private init(_ message: String, duration: TTGSnackbarDuration = .middle) {
        self.snack = TTGSnackbar(message: message, duration: duration)
    }
    
    public func setMessage(_ text: String) -> Self {
        self.snack.message = text
        return self
    }
    
    public func setDuration(_ duration: TTGSnackbarDuration) -> Self {
        self.snack.duration = duration
        return self
    }
    
    public func setAnimation(_ animation: TTGSnackbarAnimationType) -> Self {
        self.snack.animationType = animation
        return self
    }
    
    public func setActionText(_ text: String) -> Self {
        self.snack.actionText = text
        return self
    }
    
    public func setActionText(_ actionBlock: @escaping TTGSnackbar.TTGActionBlock) -> Self {
        self.snack.actionBlock = actionBlock
        return self
    }
    
    public func setBackgroundColor(_ color: UIColor) -> Self {
        self.snack.backgroundColor = color
        return self
    }
    
    public func setMessageTextColor(_ color: UIColor) -> Self {
        self.snack.messageTextColor = color
        return self
    }
    
    public func build() -> TTGSnackbar {
        return self.snack
    }
}

// MARK: - UIViewController Extension

extension UIViewController {
    
    public var internetSnackbar: InternetSnackbar {
        get {
            .shared
        }
    }
}
