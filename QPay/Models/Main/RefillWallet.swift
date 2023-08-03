//
//  RefillWallet.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct RefillWallet : Mappable {
    
    var serviceCharge: Double?
    var baseAmount: Double?
    var totalAmount: Double?
    var paymentLink: String?
    
    var _paymentLink: String {
        get {
            return paymentLink ?? ""
        }
    }
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.serviceCharge <- map["service_charge"]
        self.baseAmount <- map["BaseAmount"]
        self.totalAmount <- map["TotalAmount"]
        self.paymentLink <- map["PaymentLink"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
