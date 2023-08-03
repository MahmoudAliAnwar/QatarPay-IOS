//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class Cart: PCart {
    
    private static var object: Cart!
    
    public static var shared: Cart {
        if object == nil {
            let cart = Cart()
            return cart
        }else {
            return object
        }
    }
    
    private lazy var userProfile: UserProfile! = {
        return UserProfile.shared
    }()
    
    private init() {
    }
    
    /**
    Add product quantity into UserProfile...

    - parameter product: Product Object.
    - returns: Void
    - warning: No Warning


     # Notes: #
     1. If product is exists in UserProfile, it will increase quantity (plus 1)
     2. If product is not exists in UserProfile, it will make a new cart item with quantity 1

     # Example #
    ```
     // cart.saveItem(product)
    ```
    */
    public func addItem(_ product: Product) {
        
        var fileItems = self.getCartItems()
        let checkProduct = self.checkProduct(product)
        
        if checkProduct.isExists {
            fileItems[checkProduct.index].quantity += 1
            
        }else {
            fileItems.append(.init(product: product, quantity: 1))
        }
        self.saveItems(fileItems)
    }
    
    /**
     Remove product quantity from UserProfile...
     
     - parameter product: Product Object.
     - returns: Void
     - warning: No Warning
     
     
     # Notes: #
     1. If product quantity is greater than 1 it will decrease 1
     2. If product quantity is 1 it will remove product from cart
     
     # Example #
     ```
     // cart.removeItem(product)
     ```
     */
    public func removeItem(_ product: Product) {
        
        var fileItems = self.getCartItems()
        let checkProduct = self.checkProduct(product)
        
        if checkProduct.isExists {
            if fileItems[checkProduct.index].quantity > 1 {
                fileItems[checkProduct.index].quantity -= 1
            }else {
                fileItems.remove(at: checkProduct.index)
            }
            self.saveItems(fileItems)
        }
    }
    
    public func removeCartItems() {
        self.userProfile.removeCartItems()
    }
    
    public func getCartItems() -> [CartItem] {
        return self.userProfile.getCartItems()
    }
    
    public func getCartItemsCount() -> Int {
        return self.getCartItems().count
    }

    public func getCartItemsQuantites() -> Int {
        
        let items = self.getCartItems()
        var array = [Int]()
        
        items.forEach({ array.append($0.quantity) })
        
        return array.reduce(0, +)
    }

    public func getCartSubTotal() -> Double {
        
        let items = self.getCartItems()
        var array = [Double]()
        
        items.forEach { (item: CartItem) in
            if let price = item.product.price {
                let multiply = Double(item.quantity) * price
                array.append(multiply)
            }
        }
        
        let subTotal = array.reduce(0, +)
        return subTotal
    }
    
    /// Save cart items into UserDefaults ...
    private func saveItems(_ items: [CartItem]) {
        self.userProfile.saveCartItems(items)
    }
    
    private func checkProduct(_ product: Product) -> (isExists: Bool, index: Int) {
        
        for (index, item) in self.getCartItems().enumerated() {
            if item.product == product {
                return (true, index)
            }
        }
        return (false, -1)
    }
    
//    private func insertItem(_ item: CartItem) {
//        var fileItems = self.getCartItems()
//        fileItems.append(item)
//        self.saveItems(fileItems)
//    }
//
//    private func updateItem(_ item: CartItem) {
//
//        var fileItems = self.getCartItems()
//        for (i, it) in fileItems.enumerated() {
//            if it.product == item.product {
//                fileItems[i].quantity = item.quantity
//                self.saveItems(fileItems)
//                break
//            }
//        }
//    }
//
//    public func saveItem(_ item: CartItem) {
//
//        var fileItems = self.getCartItems()
//
//        if fileItems.contains(where: { $0.product == item.product }) {
//            for (i, it) in fileItems.enumerated() {
//                if it.product == item.product {
//                    fileItems[i].quantity = item.quantity
//                    self.saveItems(fileItems)
//                    break
//                }
//            }
//
//        }else {
//            fileItems.append(item)
//            self.saveItems(fileItems)
//        }
//    }
//
}
