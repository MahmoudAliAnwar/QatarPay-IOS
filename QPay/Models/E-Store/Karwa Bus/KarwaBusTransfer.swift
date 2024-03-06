//
//  KarwaBusTransfer.swift
//  QPay
//
//  Created by Mohammed Hamad on 29/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct KarwaBusTransfer : Mappable {
    
    var referenceNumber: String?
    var clientReference: String?
    var requestID : Int?
    var accessToken : String?
    var verificationID : String?
    var amount : Double?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _referenceNumber: String {
        get {
            return self.referenceNumber ?? ""
        }
    }
    
    var _clientReference: String {
        get {
            return self.clientReference ?? ""
        }
    }
    
    var _requestID: Int {
        get {
            return self.requestID ?? 0
        }
    }
    
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
        
        self.referenceNumber <- map["ReferenceNumber"]
        self.requestID <- map["RequestID"]
        self.accessToken <- map["AccessToken"]
        self.verificationID <- map["VerificationID"]
        self.amount <- map["Amount"]
        self.clientReference <- map["ClientReference"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
