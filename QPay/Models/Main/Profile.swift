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

struct Profile : Mappable, Codable {
    
    var userSequence : Int?
    var email : String?
    var nationality : String?
    var gender : String?
    var role : String?
    var userName : String?
    var company : String?
    var countryID : Int?
    var userStatusID : Int?
    var fullName : String?
    var fax : String?
    var city : String?
    var address : String?
    var imageURL : String?
    var mobile : String?
    var website : String?
    var userStatus : String?
    var emailVerified : Bool?
    var lastName : String?
    var firstName : String?
    var roleNme : String?
    var phoneNumberConfirmed : Bool?
    var telephone : String?
    var pinEnabled : Bool?
    var qidVerified : Bool?
    var qidNumber : String?
    var passportNumber : String?
    var buildingNumber : String?
    var streetNumber : String?
    var zone : String?
    var longitude: String?
    var latitude: String?
    var passportVerified : Bool?
    
    enum Gender: String, CaseIterable {
        case Male
        case Female
        
        var serverType: Int {
            get {
                switch self {
                case .Female: return 1
                case .Male: return 2
                }
            }
        }
    }
    
    enum AccountStatus: String, CaseIterable {
        case new = "New"
        case active = "Active"
        case porhibited = "Porhibited"
    }
    
    var _email: String {
        get {
            return self.email ?? ""
        }
    }
    
    var _fullName: String {
        get {
            return self.fullName ?? ""
        }
    }
    
    var _lastName: String {
        get {
            return self.lastName ?? ""
        }
    }
    
    var _nationality: String {
        get {
            return self.nationality ?? ""
        }
    }
    
    var _genderString: String {
        get {
            return self.gender ?? ""
        }
    }
    
    var _gender: Gender? {
        get {
            return Gender(rawValue: self._genderString)
        }
    }
    
    var _mobile: String {
        get {
            return self.mobile ?? ""
        }
    }
    
    var _qidNumber: String {
        get {
            return self.qidNumber ?? ""
        }
    }
    
    var _passportNumber: String {
        get {
            return self.passportNumber ?? ""
        }
    }
    
    var _buildingNumber: String {
        get {
            return self.buildingNumber ?? ""
        }
    }
    
    var _streetNumber: String {
        get {
            return self.streetNumber ?? ""
        }
    }
    
    var _zone: String {
        get {
            return self.zone ?? ""
        }
    }
    
    var _address: String {
        get {
            return self.address ?? ""
        }
    }
    
    var _emailVerified: Bool {
        get {
            return self.emailVerified ?? false
        }
    }
    
    var _phoneNumberConfirmed: Bool {
        get {
            return self.phoneNumberConfirmed ?? false
        }
    }
    
    var _pinEnabled: Bool {
        get {
            return self.pinEnabled ?? false
        }
    }
    
    var _qidVerified: Bool {
        get {
            return self.qidVerified ?? false
        }
    }
    
    var _passportVerified: Bool {
        get {
            return self.passportVerified ?? false
        }
    }
    
    var _userStatus: String {
        get {
            return self.userStatus ?? ""
        }
    }
    
    var _userStatusObject: AccountStatus? {
        get {
            return AccountStatus(rawValue: self._userStatus)
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.userSequence <- map["UserSequence"]
        self.email <- map["Email"]
        self.nationality <- map["Nationality"]
        self.gender <- map["Gender"]
        self.role <- map["Role"]
        self.userName <- map["UserName"]
        self.company <- map["Company"]
        self.countryID <- map["CountryID"]
        self.userStatusID <- map["UserStatusID"]
        self.fullName <- map["FullName"]
        self.fax <- map["Fax"]
        self.city <- map["City"]
        self.address <- map["Address"]
        self.imageURL <- map["ImageURL"]
        self.mobile <- map["Mobile"]
        self.website <- map["Website"]
        self.userStatus <- map["UserStatus"]
        self.emailVerified <- map["EmailVerified"]
        self.lastName <- map["LastName"]
        self.firstName <- map["FirstName"]
        self.roleNme <- map["RoleNme"]
        self.phoneNumberConfirmed <- map["PhoneNumberConfirmed"]
        self.telephone <- map["Telephone"]
        self.pinEnabled <- map["PinEnabled"]
        self.qidVerified <- map["QIDVerified"]
        self.qidNumber <- map["QIDNumber"]
        self.passportNumber <- map["PassportNumber"]
        self.buildingNumber <- map["BuildingNumber"]
        self.streetNumber <- map["StreetNumber"]
        self.zone <- map["Zone"]
        self.longitude <- map["Longitude"]
        self.latitude <- map["Latitude"]
        self.passportVerified <- map["PassportVerified"]
    }
}
