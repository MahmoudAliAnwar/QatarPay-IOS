//
//  StockHistory.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct StockHistory : Mappable , Codable {
    
    var requestID    : Int?
    var marketName   : String?
    var action       : String?
    var margin       : Double?
    var buyingPrice  : Double?
    var sellingPrice : Double?
    var quantity     : Int?
    var actionDate   : String?
    var group        : String?
    
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
    
    var _action : String {
        get {
            return action ?? ""
        }
    }
    
    var _margin : Double {
        get {
            return margin ?? 0
        }
    }
    
    var _buyingPrice : Double {
        get {
            return buyingPrice ?? 0
        }
    }
    
    var _sellingPrice : Double {
        get {
            return sellingPrice ?? 0
        }
    }
    
    var _quantity : Int {
        get {
            return quantity ?? 0
        }
    }
    
    var _actionDate : String {
        get {
            return actionDate ?? ""
        }
    }
    
    var _group : String {
        get {
            return group ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        requestID    <- map["RequestID"]
        marketName   <- map["MarketName"]
        action       <- map["Action"]
        margin       <- map["Margin"]
        buyingPrice  <- map["BuyingPrice"]
        sellingPrice <- map["SellingPrice"]
        quantity     <- map["Quantity"]
        actionDate   <- map["ActionDate"]
        group        <- map["Group"]
    }
    
}
