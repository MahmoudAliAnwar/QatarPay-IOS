//
//  Order.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/1/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Order: Mappable, Equatable {
    
    var id: Int?
    var orderNumber: String?
    var orderDate: String?
    var orderDueDate: String?
    var orderNote: String?
    var customerName: String?
    var customerEmail: String?
    var customerMobile: String?
    var companyName: String?
    var orderSubTotal: Double?
    var discount: Double?
    var deliveryCharges: Double?
    var orderTotal: Double?
    var orderStatusID: Int?
    var orderStatus: String?
    var paymentStatusID: Int?
    var paymentStatus: String?
    var paymentURL: String?
    var orderDetails: [OrderDetails]?
    var shopID: Int?
    var shopName: String?
    var shopImage: String?
    var shopBanner: String?
    var shopDescription: String?
    
    var _id: Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _orderNumber: String {
        get {
            return self.orderNumber ?? ""
        }
    }
    
    var _orderDate: String {
        get {
            return self.orderDate ?? ""
        }
    }
    
    var _orderDueDate: String {
        get {
            return self.orderDueDate ?? ""
        }
    }
    
    var _orderNote: String {
        get {
            return self.orderNote ?? ""
        }
    }
    
    var _paymentStatus: String {
        get {
            return self.paymentStatus ?? ""
        }
    }
    
    var _companyName: String {
        get {
            return self.companyName ?? ""
        }
    }
    
    var _customerName: String {
        get {
            return self.customerName ?? ""
        }
    }
    
    var _customerMobile: String {
        get {
            return self.customerMobile ?? ""
        }
    }
    
    var _customerEmail: String {
        get {
            return self.customerEmail ?? ""
        }
    }
    
    var _orderSubTotal: Double {
        get {
            return self.orderSubTotal ?? 0.0
        }
    }
    
    var _discount: Double {
        get {
            return self.discount ?? 0.0
        }
    }
    
    var _deliveryCharges: Double {
        get {
            return self.deliveryCharges ?? 0.0
        }
    }
    
    var _orderTotal: Double {
        get {
            return self.orderTotal ?? 0.0
        }
    }
    
    var _shopID: Int {
        get {
            return self.shopID ?? 0
        }
    }
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["OrderID"]
        self.orderNumber <- map["OrderNumber"]
        self.orderDate <- map["OrderDate"]
        self.orderDueDate <- map["OrderDueDate"]
        self.orderNote <- map["OrderNote"]
        self.customerName <- map["CustomerName"]
        self.customerEmail <- map["CustomerEmail"]
        self.customerMobile <- map["CustomerMobile"]
        self.companyName <- map["CompanyName"]
        self.orderSubTotal <- map["OrderSubTotal"]
        self.discount <- map["Discount"]
        self.deliveryCharges <- map["DeliveryCharges"]
        self.orderTotal <- map["OrderTotal"]
        self.orderStatusID <- map["OrderStatusID"]
        self.orderStatus <- map["OrderStatus"]
        self.paymentStatusID <- map["PaymentStatusID"]
        self.paymentStatus <- map["PaymentStatus"]
        self.paymentURL <- map["PaymentURL"]
        self.orderDetails <- map["OrderDetail"]
        self.shopID <- map["ShopID"]
        self.shopName <- map["ShopName"]
        self.shopImage <- map["ShopImage"]
        self.shopBanner <- map["ShopBanner"]
        self.shopDescription <- map["ShopDescription"]
    }
}
