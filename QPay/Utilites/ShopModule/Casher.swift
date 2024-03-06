//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

class Casher: PCasher {
    
    private static var object: Casher!
    
    public static var shared: Casher {
        if object == nil {
            object = Casher()
        }
        return object
    }
    
    private init() {}
    
    func createOrder(_ cart: PCart, discount: Double, delivery: Double) -> Order {
        
        var order = Order()
        let fileCartItems = cart.getCartItems()
        var orderItems = [OrderDetails]()
        
        fileCartItems.forEach { (item) in
            let prod = item.product
            let price = prod.price ?? 0.0
            let quantity = Double(item.quantity)
            orderItems.append(.init(productID: prod.id ?? -1,
                                    productName: prod.name ?? "",
                                    productDescription: prod.description ?? "",
                                    quantity: quantity,
                                    price: price,
                                    total: (quantity * price))
            )
        }
        
        order.discount = discount
        order.deliveryCharges = delivery
        order.orderDetails = orderItems
        
        let subTotal = cart.getCartSubTotal()
        order.orderSubTotal = subTotal
        order.orderTotal = self.calcTotal(subTotal, discount: discount, delivery: delivery)
        
        return order
    }
    
    public func calcTotal(_ subTotal: Double, discount: Double, delivery: Double) -> Double {
        return (subTotal - discount) + delivery
    }
    
    private func calcNetTotal(_ subTotal: Double, discount: Double) -> Double {
        if discount > 0 {
            let dicsountValue = ((100 - discount) / 100) * subTotal
            return dicsountValue
        }
        return 0.0
    }
    
    private func calcDiscount(_ subTotal: Double, discount: Double) -> Double {
        if discount > 0 {
            let dicsountValue = (discount / 100) * subTotal
            return dicsountValue
        }
        return 0.0
    }
}
