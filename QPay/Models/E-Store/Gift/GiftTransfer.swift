//
//  GiftTransfer.swift
//  QPay
//
//  Created by Mohammed Hamad on 03/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GiftTransfer : Mappable {
    
    var accessToken : String?
    var verificationID : String?
    var requestID : String?
    var amount : Double?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _accessToken: String {
        get {
            return self.accessToken ?? ""
        }
    }
    
    var _verificationID: String {
        get {
            return self.verificationID ?? ""
        }
    }
    
    var _requestID: String {
        get {
            return self.requestID ?? ""
        }
    }
    
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
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        accessToken <- map["AccessToken"]
        verificationID <- map["VerificationID"]
        requestID <- map["RequestID"]
        amount <- map["Amount"]
        
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
}

