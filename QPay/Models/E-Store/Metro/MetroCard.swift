//
//  MetroCard.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/12/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation

import ObjectMapper

struct MetroCard : Mappable {
    
    var isValid : Bool?
    var number : String?
    var cardType : Int?
    var metroCardType : String?
    var thumbnail : String?
    var balance : Double?
    var id : Int?
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _balance: Double {
        get {
            return self.balance ?? 0.0
        }
    }
    
    var _cardType: Int {
        get {
            return self.cardType ?? 0
        }
    }
    
    var _metroCardType: String {
        get {
            return self.metroCardType ?? ""
        }
    }
    
    var _thumbnail: String {
        get {
            return self.thumbnail ?? ""
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        isValid <- map["IsValid"]
        number <- map["CardNumber"]
        cardType <- map["CardType"]
        metroCardType <- map["MetroCardType"]
        thumbnail <- map["Thumbnail"]
        balance <- map["Balance"]
        id <- map["CardID"]
    }
}
