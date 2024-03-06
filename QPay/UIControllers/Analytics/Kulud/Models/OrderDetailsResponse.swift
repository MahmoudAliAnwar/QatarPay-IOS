//
//  
//  OrderDetailsResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

struct OrderDetailsResponse : Codable {
    
    var orderDetails: [KuludOrderDetails]?
    var orderStatus: KuludOrderStatus?
    var cart: CartModel?
    
    var _orderDetails: [KuludOrderDetails] {
        get {
            return self.orderDetails ?? []
        }
    }
}

struct KuludOrderStatus : Codable {
    var id: Int?
    var orderId: String?
    var status: Int?
    var createDateTime: String? /// "createDateTime": "2022-01-12T16:32:01.956056"
    
    var _status: Int {
        get {
            return self.status ?? -1
        }
    }
    
    var statusObject: KuludOrder.OrderStatus? {
        get {
            return KuludOrder.OrderStatus(rawValue: self._status)
        }
    }
}
