//
//  PaymentRequestViaBillResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaymentRequestViaBillResponse : Mappable {
    
    var accessToken    : String?
    var details        : [String]?
    var verificationID : String?
    var requestID      : [String]?
    
    var success        : Bool?
    var code           : String?
    var message        : String?
    var errors         : [String]?
    
    var _accessToken : String {
        get {
            return self.accessToken ?? ""
        }
    }
    
    var _details : [String] {
        get {
            return self.details ?? []
        }
    }
    
    var _verificationID : String {
        get {
            return self.verificationID ?? ""
        }
    }
    
    var _requestID : [String] {
        get {
            return self.requestID ?? []
        }
    }
    
    var _success : Bool {
        get {
            return self.success ?? false
        }
    }
    
    var _code : String {
        get {
            return self.code ?? ""
        }
    }
    
    var _message : String {
        get {
            return self.message ?? ""
        }
    }
    
    var _errors : [String] {
        get {
            return self.errors ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        accessToken    <- map["AccessToken"]
        details        <- map["Details"]
        verificationID <- map["VerificationID"]
        requestID      <- map["RequestID"]
        success        <- map["success"]
        code           <- map["code"]
        message        <- map["message"]
        errors         <- map["errors"]
    }
    
}
