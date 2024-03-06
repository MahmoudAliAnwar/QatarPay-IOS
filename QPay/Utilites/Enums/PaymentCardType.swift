//
//  CardType.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

enum PaymentCardType: String, CaseIterable {
    
    case Credit = "1"
    case Debit = "2"
    
    public var typeString: String {
        get {
            switch self {
            case .Credit: return "Credit"
            case .Debit: return "Debit"
            }
        }
    }
}
