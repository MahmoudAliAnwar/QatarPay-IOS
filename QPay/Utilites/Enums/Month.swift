//
//  ServerDateFormat.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/19/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum Month: Int {
    case January = 1, February, March, April, May, June, July, August, September, October, November, December
    
    /// Return month in string value
    var description: String {
        switch self {
        case .January:
            return "Jan"
        case .February:
            return "Feb"
        case .March:
            return "Mar"
        case .April:
            return "Apr"
        case .May:
            return "May"
        case .June:
            return "Jun"
        case .July:
            return "Jul"
        case .August:
            return "Aug"
        case .September:
            return "Sep"
        case .October:
            return "Oct"
        case .November:
            return "Nov"
        case .December:
            return "Dec"
        }
    }
}
