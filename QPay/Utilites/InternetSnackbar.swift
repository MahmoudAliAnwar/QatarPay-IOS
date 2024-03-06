//
//  InternetSnackbar.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/08/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar

public struct InternetSnackbar {
    
    private let snack: TTGSnackbar
    
    private static var object: InternetSnackbar!
    
    public static var shared: InternetSnackbar {
        get {
            if object == nil {
                object = InternetSnackbar()
            }
            return object
        }
    }
    
    private init() {
        self.snack = SnackbarBuilder.getInstance("Please check your internet connection")
            .setDuration(.forever)
            .setBackgroundColor(.red)
            .setMessageTextColor(.white)
            .build()
    }
    
    public func show() {
        self.snack.show()
    }
    
    public func dismiss() {
        self.snack.dismiss()
    }
}
