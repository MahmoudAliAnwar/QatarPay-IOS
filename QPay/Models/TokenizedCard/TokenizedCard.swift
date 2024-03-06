//
//  TokenizedCard.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct TokenizedCard : Mappable , Codable  {
    
    var id                 : Int?
    var cardName           : String?
    var cardType           : String?
    var cardNumber         : String?
    var ownerName          : String?
    var expiryDate         : String?
    var cvv                : String?
    var paymentCardType    : String?
    var entryTime          : String?
    var modifiedBy         : Int?
    var userID             : Int?
    var modifiedTime       : String?
    var qpan               : String?
    var reminderType       : String?
    var cardFrontImagePath : String?
    var cardBackImagePath  : String?
    var reminderTypeText   : String?
    var isDefault          : Bool?
    
    var _id : Int {
        get {
            return id ?? 0
        }
    }
    
    var _cardName : String {
        get {
            return cardName ?? ""
        }
    }
    
    var _cardType : String {
        get {
            return cardType ?? ""
        }
    }
    
    var _cardNumber : String {
        get {
            return cardNumber ?? ""
        }
    }
    
    var _ownerName : String {
        get {
            return ownerName ?? ""
        }
    }
    
    var _expiryDate : String {
        get {
            return expiryDate ?? ""
        }
    }
    
    var _cvv : String {
        get {
            return cvv ?? ""
        }
    }
    
    var _paymentCardType : String {
        get {
            return paymentCardType ?? ""
        }
    }
    
    var _entryTime : String {
        get {
            return entryTime ?? ""
        }
    }
    
    var _modifiedBy : Int {
        get {
            return modifiedBy ?? 0
        }
    }
    
    var _userID : Int {
        get {
            return userID ?? 0
        }
    }
    
    var _modifiedTime : String {
        get {
            return modifiedTime ?? ""
        }
    }
    
    var _qpan : String {
        get {
            return qpan ?? ""
        }
    }
    
    var _reminderType : String {
        get {
            return reminderType ?? ""
        }
    }
    
    var _cardFrontImagePath : String {
        get {
            return cardFrontImagePath ?? ""
        }
    }
    
    var _cardBackImagePath : String {
        get {
            return cardBackImagePath ?? ""
        }
    }
    
    var _reminderTypeText : String {
        get {
            return reminderTypeText ?? ""
        }
    }
    
    var _isDefault : Bool {
        get {
            return isDefault ?? false
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id                 <- map["ID"]
        cardName           <- map["CardName"]
        cardType           <- map["CardType"]
        cardNumber         <- map["CardNumber"]
        ownerName          <- map["OwnerName"]
        expiryDate         <- map["ExpiryDate"]
        cvv                <- map["CVV"]
        paymentCardType    <- map["PaymentCardType"]
        entryTime          <- map["EntryTime"]
        modifiedBy         <- map["ModifiedBy"]
        userID             <- map["UserID"]
        modifiedTime       <- map["ModifiedTime"]
        qpan               <- map["QPAN"]
        reminderType       <- map["ReminderType"]
        cardFrontImagePath <- map["CardFrontImagePath"]
        cardBackImagePath  <- map["CardBackImagePath"]
        reminderTypeText   <- map["ReminderTypeText"]
        isDefault          <- map["IsDefault"]
    }
    
}
