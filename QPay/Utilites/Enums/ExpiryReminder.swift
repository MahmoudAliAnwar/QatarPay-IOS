//
//  ExpiryReminder.swift
//  QPay
//
//  Created by Dev. Mohmd on 11/3/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum ExpiryReminder: String, CaseIterable {
    
    case Before1Month = "1 Month Before Expiry"
    case Before15Days = "15 Days Before Expiry"
    case Before1Week = "1 Week Before Expiry"
    
    var serverType: String {
        switch self {
        case .Before1Month:
            return "1"
        case .Before15Days:
            return "2"
        case .Before1Week:
            return "3"
        }
    }
    
    static func getObjectByNumber(_ number: String) -> Self? {
        for object in Self.allCases {
            if object.serverType == number {
                return object
            }
        }
        return nil
    }
}
