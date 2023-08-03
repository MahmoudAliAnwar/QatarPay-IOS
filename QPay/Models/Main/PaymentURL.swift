//
//  RefillWallet.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaymentURL : Mappable {
    
    var paypalLink : String?
    var napsLink : String?
    var creditCardLink : String?
    var mobileLink : String?
    var cyberSecureLink : String?
    var iBCardLink : String?
    var oTPLink : String?
    var vodafoneLink : String?
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        paypalLink <- map["PaypalLink"]
        napsLink <- map["NapsLink"]
        creditCardLink <- map["CreditCardLink"]
        mobileLink <- map["MobileLink"]
        cyberSecureLink <- map["CyberSecureLink"]
        iBCardLink <- map["IBCardLink"]
        oTPLink <- map["OTPLink"]
        vodafoneLink <- map["VodafoneLink"]
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }

}
