//
//  ShopConcrete.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class ShopConcrete {
    
    private static var object: ShopConcrete!
    
    public static var shared: ShopConcrete {
        if object == nil {
            let cart = ShopConcrete()
            return cart
        }else {
            return object
        }
    }
    
    public var casher: PCasher!
    
    private init() {
        self.casher = Casher.shared
    }
}
