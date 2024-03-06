//
//  BankDetails.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//


import Foundation
import ObjectMapper

struct Bank : Mappable {
    
    var iD : Int?
    var countryName : String?
    var accountName : String?
    var name : String?
    var accountNumber : String?
    var userID : String?
    var entryTime : String?
    var ownerName : String?
    var iban : String?
    var swiftCode : String?
    var bankNameID : String?
    var imageLocation : String?
    
    var _iD : Int {
        get {
            return iD ?? 0
        }
    }
    
    var _countryName : String {
        get {
            return countryName ?? ""
        }
    }
    
    var _accountName : String {
        get {
            return accountName ?? ""
        }
    }
    
    var _name : String {
        get {
            return name ?? ""
        }
    }
    
    var _accountNumber : String {
        get {
            return accountNumber ?? ""
        }
    }
    
    var _userID : String {
        get {
            return userID ?? ""
        }
    }
    
    var _entryTime : String {
        get {
            return entryTime ?? ""
        }
    }
    
    var _ownerName : String {
        get {
            return ownerName ?? ""
        }
    }
    
    var _iban : String {
        get {
            return iban ?? ""
        }
    }
    
    var _swiftCode : String {
        get {
            return swiftCode ?? ""
        }
    }
    
    var _bankNameID : String {
        get {
            return bankNameID ?? ""
        }
    }
    
    var _imageLocation : String {
        get {
            return imageLocation ?? ""
        }
    }
    
    init() {
        
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        iD <- map["ID"]
        countryName <- map["CountryName"]
        accountName <- map["AccountName"]
        name <- map["BankName"]
        accountNumber <- map["AccountNumber"]
        userID <- map["UserID"]
        entryTime <- map["EntryTime"]
        ownerName <- map["OwnerName"]
        iban <- map["IBAN"]
        swiftCode <- map["SwiftCode"]
        bankNameID <- map["BankNameID"]
        imageLocation <- map["ImageLocation"]
    }
}
