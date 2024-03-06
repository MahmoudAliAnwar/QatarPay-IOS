//
//  InvoicePaidStatus.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/28/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum InvoicePaidStatus: Int, CaseIterable {
    
    /// "Pending" => 1
    case Pending = 1
    /// "Failed" => 2
    case Failed = 2
    /// "Success" => 3
    case Online = 3
    /// "CashCollected" => 4
    case Cash = 4
    
    var title: String {
        switch self.rawValue {
        case 1 :
            return "Pending"
        case 2 :
            return "Failed"
        case 3 :
            return "Online"
        case 4 :
            return "Cash"
        default:
            return ""
        }
    }
    
    /// Old Categories ...
//    case Completed = "Completed"
//    case Pending = "Pending"
//    case Cancelled = "Cancelled"
//    case Request_Error = "Request Error"
//    case Payment_Failed = "Payment Failed"
}

/*
    Pending = 1, ---> Pending
    Failed = 2, ---> Pending
    Success = 3, ---> Online
    CashCollected = 4,---> Cash
 */
