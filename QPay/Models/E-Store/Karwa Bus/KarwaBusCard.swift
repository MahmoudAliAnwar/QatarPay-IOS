//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct KarwaBusCard : Mappable {
    
    var isValid : Bool?
    var number : String?
    var thumbnail : String?
    var balance : Double?
    var id : Int?
    var lastUsageDateTime : String?
    var lastRechargeDateTime : String?
    var mobile : String?
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _balance: Double {
        get {
            return self.balance ?? 0.0
        }
    }
    
    var _mobile: String {
        get {
            return self.mobile ?? ""
        }
    }
    
    var _lastUsageDateTime: String {
        get {
            return self.lastUsageDateTime ?? ""
        }
    }
    
    var _lastRechargeDateTime: String {
        get {
            return self.lastRechargeDateTime ?? ""
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        self.isValid <- map["IsValid"]
        self.number <- map["CardNumber"]
        self.thumbnail <- map["Thumbnail"]
        self.balance <- map["Balance"]
        self.id <- map["CardID"]
        self.lastUsageDateTime <- map["LastUsageDateTime"]
        self.lastRechargeDateTime <- map["LastRechargeDateTime"]
        self.mobile <- map["MobileNumber"]
    }
}
