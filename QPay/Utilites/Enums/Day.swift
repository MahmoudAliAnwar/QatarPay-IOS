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
            return "Saturday"
        case .Sunday:
            return "Sunday"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        }
    }
}
