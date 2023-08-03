//
//  User.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct User : Mappable, Codable {
    
    var access_token : String?
    var token_type : String?
    var password : String?
    var expires_in : Int?
    var userName : String?
    var lastName : String?
    var firstName : String?
    var role : String?
    var imageLocation : String?
    var email : String?
    var emailConfirmed : String?
    var mobileNumber : String?
    var phoneConfirmed : String?
    var qIDConfirmed : String?
    var userCode : String?
    var userType : String?
    var balance : String?
    var isDigitalSignature : String?
    var qpanExpiry : String?
    var isPinVerified : String?
    var accountLevel : String?
    var loyalityBalance : String?
    var issued : String?
    var expires : String?
    
    var _userName: String {
        get {
            return self.userName ?? ""
        }
    }
    
    var _firstName: String {
        get {
            return self.firstName ?? ""
        }
    }
    
    var _lastName: String {
        get {
            return self.lastName ?? ""
        }
    }
    
    var _fullName: String {
        get {
            return "\(self._firstName) \(self._lastName)"
        }
    }
    
    var _mobileNumber: String {
        get {
            return self.mobileNumber ?? ""
        }
    }
    
    var _email: String {
        get {
            return self.email ?? ""
        }
    }
    
    var _userCode: String {
        get {
            return self.userCode ?? ""
        }
    }
    
    var _userType: String {
        get {
            return self.userType ?? ""
        }
    }
    
    var _balance: String {
        get {
            return self.balance ?? ""
        }
    }
    
    var _access_token: String {
        get {
            return self.access_token ?? ""
        }
    }
    
    var _password: String {
        get {
            return self.password ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        access_token <- map["access_token"]
        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        userName <- map["userName"]
        lastName <- map["LastName"]
        firstName <- map["FirstName"]
        role <- map["Role"]
        imageLocation <- map["ImageLocation"]
        email <- map["Email"]
        emailConfirmed <- map["EmailConfirmed"]
        mobileNumber <- map["MobileNumber"]
        phoneConfirmed <- map["PhoneConfirmed"]
        qIDConfirmed <- map["QIDConfirmed"]
        userCode <- map["UserCode"]
        userType <- map["UserType"]
        balance <- map["Balance"]
        isDigitalSignature <- map["IsDigitalSignature"]
        qpanExpiry <- map["QPANExpiry"]
        isPinVerified <- map["IsPinVerified"]
        accountLevel <- map["AccountLevel"]
        loyalityBalance <- map["LoyalityBalance"]
        issued <- map[".issued"]
        expires <- map[".expires"]
    }

}

