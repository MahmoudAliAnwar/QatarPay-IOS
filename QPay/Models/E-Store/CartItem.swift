//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

struct CartItem: Codable, Equatable {
    
    var product : Product
    var quantity : Int
    
    var total: Double {
        get {
            return self.product.price ?? 1.0 * Double(self.quantity)
        }
    }
}
