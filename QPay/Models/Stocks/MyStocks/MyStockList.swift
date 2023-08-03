//
//  MyStockList.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct MyStockList : Mappable {
    
    var requestID    : Int?
    var marketName   : String?
    var stockName    : String?
    var quantity     : Int?
    var price        : Double?
    var purchaseDate : String?
    
    var _requestID : Int {
        get {
     return requestID ?? 0
        }
    }
    
    var _marketName : String {
        get {
     return marketName ?? ""
        }
    }
    
    var _stockName : String {
        get {
     return stockName ?? ""
        }
    }
    
    var _quantity : Int {
        get {
     return quantity ?? 0
        }
    }
    
    var _price : Double {
        get {
            return price ?? 0.0
        }
    }
    
    var _purchaseDate : String {
        get {
     return purchaseDate ?? ""
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        requestID    <- map["RequestID"]
        marketName   <- map["MarketName"]
        stockName    <- map["StockName"]
        quantity     <- map["Quantity"]
        price        <- map["Price"]
        purchaseDate <- map["PurchaseDate"]
    }
}
