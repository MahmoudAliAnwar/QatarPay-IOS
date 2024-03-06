//
//  RefillWallet.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PassportDetails : Mappable {
    
    var frontSide : String?
    var number : String?
    var expiryDate : String?
    var reminderTypeID : Int?
    var reminderType : String?
    var isVerified : Bool?
    var expiryStatus : Bool?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _frontSide: String {
        get {
            return self.frontSide ?? ""
        }
    }
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _expiryDate: String {
        get {
            return self.expiryDate ?? ""
        }
    }
    
    var _isVerified: Bool {
        get {
            return self.isVerified ?? false
        }
    }
    
    var _expiryStatus: Bool {
        get {
            return self.expiryStatus ?? false
        }
    }
    
    var _reminderTypeID: Int {
        get {
            return self.reminderTypeID ?? -1
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
        
        self.frontSide <- map["PassportFront"]
        self.number <- map["PassportNumber"]
        self.expiryDate <- map["ExpiryDate"]
        self.reminderTypeID <- map["ReminderTypeID"]
        self.reminderType <- map["ReminderType"]
        self.isVerified <- map["PassportVerified"]
        self.expiryStatus <- map["ExpiryStatus"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
