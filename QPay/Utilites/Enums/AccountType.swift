//
//  AccountType.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

enum AccountType: String {
    case admin = "Admin"
    case merchant = "Merchant"
    case qatarPay = "Qatar Pay User"
    
    var serverAccountNumber: Int {
        get {
            switch self {
            case .admin: return 1
            case .merchant: return 2
            case .qatarPay: return 3
            }
        }
    }
}
