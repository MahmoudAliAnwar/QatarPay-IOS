//
//  ValidateQR_Code.swift
//  QPay
//
//  Created by Dev. Mohmd on 10/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ValidateMerchantQRCode : Mappable {
    
    var transactionDescription : String?
    var requestDate : String?
    var merchantReference : String?
    var merchantName : String?
    var merchantLogo : String?
    var merchantCompanyName : String?
    var merchantPhoneNumber : String?
    var merchantMobile : String?
    var amount : Double?
    var sessionID : String?
    var UUID : String?
    var merchantEmail: String?
    var qpan: String?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    /// Special Variable (Not from API)
    var qrCodeData: String?

    var _amount: Double {
        get {
            return self.amount ?? 0.0
        }
    }
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        transactionDescription <- map["TransactionDescription"]
        requestDate <- map["RequestDate"]
        merchantReference <- map["MerchantReference"]
        merchantName <- map["MerchantName"]
        merchantLogo <- map["MerchantLogo"]
        merchantCompanyName <- map["MerchantCompanyName"]
        merchantPhoneNumber <- map["MerchantPhoneNumber"]
        merchantMobile <- map["MerchantMobile"]
        amount <- map["Amount"]
        sessionID <- map["SessionID"]
        UUID <- map["UUID"]
        merchantEmail <- map["MerchantEmail"]
        qpan <- map["QPAN"]
        
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
}

