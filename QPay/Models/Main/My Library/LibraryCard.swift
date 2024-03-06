//
//  PaymentCardLists.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

struct LibraryCard : Mappable, Equatable, Decodable {
    
    var id: Int?
    var name: String?
    var cardType: String?
    var number: String?
    var ownerName: String?
    var expiryDate: String?
    var cvv: String?
    /// 1: Credit, 2: Debit
    var paymentCardType: String?
    var entryTime: String?
    var modifiedBy: String?
    var userID: String?
    var modifiedTime: String?
    var qpan: String?
    var reminderType: String?
    var frontImagePath: String?
    var backImagePath: String?
    var reminderTypeText: String?
    
    var _name: String {
        get {
            return self.name ?? ""
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
    
    var _cvv: String {
        get {
            return self.cvv ?? ""
        }
    }
    
    var _ownerName: String {
        get {
            return self.ownerName ?? ""
        }
    }
    
    var _paymentCardType: String {
        get {
            return self.paymentCardType ?? ""
        }
    }
    
    var _reminderType: String {
        get {
            return self.reminderType ?? ""
        }
    }
    
    var _cardType: String {
        get {
            return self.cardType ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["ID"]
        self.name <- map["CardName"]
        self.cardType <- map["CardType"]
        self.number <- map["CardNumber"]
        self.ownerName <- map["OwnerName"]
        self.expiryDate <- map["ExpiryDate"]
        self.cvv <- map["CVV"]
        self.paymentCardType <- map["PaymentCardType"]
        self.entryTime <- map["EntryTime"]
        self.modifiedBy <- map["ModifiedBy"]
        self.userID <- map["UserID"]
        self.modifiedTime <- map["ModifiedTime"]
        self.qpan <- map["QPAN"]
        self.reminderType <- map["ReminderType"]
        self.frontImagePath <- map["CardFrontImagePath"]
        self.backImagePath <- map["CardBackImagePath"]
        self.reminderTypeText <- map["ReminderTypeText"]
    }
}
