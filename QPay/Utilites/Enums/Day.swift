//
//  ServerDateFormat.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum Day: Int {
    case Saturday = 0, Sunday, Monday, Tuesday, Wednesday, Thursday, Friday
    
    /// Return day in string value
    var description: String {
        switch self {
        case .Saturday:
            return "Sat"
        case .Sunday:
            return "Sun"
        case .Monday:
            return "Mon"
        case .Tuesday:
            return "Tue"
        case .Wednesday:
            return "Wed"
        case .Thursday:
            return "Thu"
        case .Friday:
            return "Fri"
        }
    }
}
