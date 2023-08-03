//
//  
//  MetroFareCard.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct MetroFareCard : Mappable {
    
    var type : String?
    var cardType : Int?
    var cardsDetails : [MetroFareDetails]?
    
    var _type : String {
        get {
            return type ?? ""
        }
    }
    
    var _cardType : Int {
        get {
            return cardType ?? -1
        }
    }
    
    var _cardsDetails : [MetroFareDetails] {
        get {
            return cardsDetails ?? []
        }
    }
    
    var typeObject: Types? {
        get {
            return Types(rawValue: self._type)
        }
    }
    
    enum Types: String, CaseIterable {
        case standard = "Standard"
        case gold = "Gold"
        case limited = "Limited"
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.type <- map["MetroCardType"]
        self.cardType <- map["CardType"]
        self.cardsDetails <- map["CardsDetails"]
    }
}
