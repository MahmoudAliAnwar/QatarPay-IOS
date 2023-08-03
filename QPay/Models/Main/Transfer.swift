//
//  RefillWallet.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Transfer : Mappable {
    
    var accessToken : String?
    var verificationID : String?
    var requestID : String?
    var mobileNumber : String?
    var email : String?
    var firstName : String?
    var lastName : String?
    var amount : Double?
    var qpan: String?
    var profileImage: String?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _accessToken : String {
        get {
            return accessToken ?? ""
        }
    }
    
    var _verificationID : String {
        get {
            return verificationID ?? ""
        }
    }
    
    var _requestID : String {
        get {
            return requestID ?? ""
        }
    }
    
    var _mobileNumber : String {
        get {
            return mobileNumber ?? ""
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _firstName : String {
        get {
            return firstName ?? ""
        }
    }
    
    var _lastName : String {
        get {
            return lastName ?? ""
        }
    }
    
    var _amount : Double {
        get {
            return amount ?? 0.0
        }
    }
    
    var _qpan: String {
        get {
            return qpan ?? ""
        }
    }
    
    var _profileImage: String {
        get {
            return profileImage ?? ""
        }
    }
    
    var _success : Bool {
        get {
            return success ?? false
        }
    }
    
    var _code : String {
        get {
            return code ?? ""
        }
    }
    
    var _message : String {
        get {
            return message ?? ""
        }
    }
    
    var _errors : [String] {
        get {
            return errors ?? []
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.accessToken <- map["AccessToken"]
        self.verificationID <- map["VerificationID"]
        self.requestID <- map["RequestID"]
        self.mobileNumber <- map["MobileNumber"]
        self.email <- map["Email"]
        self.firstName <- map["FirstName"]
        self.lastName <- map["LastName"]
        self.amount <- map["Amount"]
        self.qpan <- map["QPAN"]
        self.profileImage <- map["ProfileImage"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
