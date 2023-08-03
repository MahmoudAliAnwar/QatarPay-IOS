//
//  OrderItem.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/30/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct OrderItem: Codable {
    
    var ShopID: Int
    var ProductID: Int
    var Quantity: Double
    
//    init?(map: Map) {
//
//    }
//
//    init(ShopID: Int, ProductID: Int, Quantity: Double) {
//        self.ShopID = ShopID
//        self.ProductID = ProductID
//        self.Quantity = Quantity
//    }
//
//    mutating func mapping(map: Map) {
//        ShopID <- map["ShopID"]
//        ProductID <- map["ProductID"]
//        Quantity <- map["Quantity"]
//    }
}
