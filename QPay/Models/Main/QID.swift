//
//  RefillWallet.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/15/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct QID : Mappable {
    
    var number : String?
    var frontSide : String?
    var backSide : String?
    var expiryDate : String?
    var reminderTypeID : Int?
    var reminderType : String?
    var countryID: Int?
    var nationality: String?
    var dateOfBirth: String?
    var isVerified: Bool?
    
    /// Not request parameter...
    var countryName: String?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _frontSide: String {
        get {
            return self.frontSide ?? ""
        }
    }
    
    var _backSide: String {
        get {
            return self.backSide ?? ""
        }
    }
    
    var _expiryDate: String {
        get {
            return self.expiryDate ?? ""
        }
    }
    
    var _reminderTypeID: Int {
        get {
            return self.reminderTypeID ?? -1
        }
    }
    
    var _nationality: String {
        get {
            return self.nationality ?? ""
        }
    }
    
    var _dateOfBirth: String {
        get {
            return self.dateOfBirth ?? ""
        }
    }
    
    var _isVerified: Bool {
        get {
            return self.isVerified ?? false
        }
    }
    
    /// Not request parameter...
    var _countryName: String {
        get {
            return self.countryName ?? ""
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
        
        self.number <- map["QID"]
        self.frontSide <- map["QIDFront"]
        self.backSide <- map["QIDBack"]
        self.expiryDate <- map["ExpiryDate"]
        self.reminderTypeID <- map["ReminderTypeID"]
        self.reminderType <- map["ReminderType"]
        self.countryID <- map["CountryID"]
        self.nationality <- map["Nationality"]
        self.dateOfBirth <- map["DateofBirth"]
        self.isVerified <- map["IsIdVerified"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
