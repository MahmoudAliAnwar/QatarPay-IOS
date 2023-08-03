//
//  
//  MetroFareDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct MetroFareDetails : Mappable {
    
    var reusable : String?
    var thumbnail : String?
    var cardName : String?
    var cardID : Int?
    var cardFareInformation : [MetroFareInformation]?
    
    var _reusable : String {
        get {
            return reusable ?? ""
        }
    }
    
    var _thumbnail : String {
        get {
            return thumbnail ?? ""
        }
    }
    
    var _cardName : String {
        get {
            return cardName ?? ""
        }
    }
    
    var _cardID : Int {
        get {
            return cardID ?? -1
        }
    }
    
    var _cardFareInformation : [MetroFareInformation] {
        get {
            return cardFareInformation ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.reusable <- map["Reusable"]
        self.thumbnail <- map["Thumbnail"]
        self.cardName <- map["CardName"]
        self.cardID <- map["CardID"]
        self.cardFareInformation <- map["CardFareInformation"]
    }
}
