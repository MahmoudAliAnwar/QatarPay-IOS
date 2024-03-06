//
//  OrderDetail.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/1/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct OrderDetails: Mappable, Equatable {
    
    var orderID: Int?
    var shopID: Int?
    var shopName: String?
    var shopLogoLocation: String?
    var productID: Int?
    var productName: String?
    var productDescription: String?
    var quantity: Double?
    var price: Double?
    var total: Double?
    var productImageLocation: String?
    
    init?(map: Map) {
        
    }
    
    init(productID: Int, productName: String, productDescription: String, quantity: Double, price: Double, total: Double) {
        self.productID = productID
        self.productName = productName
        self.productDescription = productDescription
        self.quantity = quantity
        self.price = price
        self.total = total
    }
    
    mutating func mapping(map: Map) {
        
        orderID <- map["OrderID"]
        shopID <- map["ShopID"]
        shopName <- map["ShopName"]
        shopLogoLocation <- map["ShopLogoLocation"]
        productID <- map["ProductID"]
        productName <- map["ProductName"]
        productDescription <- map["ProductDescription"]
        quantity <- map["Quantity"]
        price <- map["Rate"]
        total <- map["Amount"]
        productImageLocation <- map["ProductImageLocation"]
    }
}
