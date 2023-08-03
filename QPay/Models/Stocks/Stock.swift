//
//  Stocks.swift
//  QPay
//
//  Created by Mohammed Hamad on 31/01/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

struct Stock: SectionModelProtocol {
    
    var name: String?
    var quantity: Double?
    var total: Double?
    var isSelected: Bool = false
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _quantity: Double {
        get {
            return self.quantity ?? 0.0
        }
    }
    
    var _total: Double {
        get {
            return self.total ?? 0.0
        }
    }
}
