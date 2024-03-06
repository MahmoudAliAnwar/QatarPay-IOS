//
//  PCart.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/26/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

protocol PCart {
    func addItem(_ product: Product)
    func removeItem(_ product: Product)
    func removeCartItems()
    func getCartItems() -> [CartItem]
    func getCartItemsCount() -> Int
    func getCartSubTotal() -> Double
}
