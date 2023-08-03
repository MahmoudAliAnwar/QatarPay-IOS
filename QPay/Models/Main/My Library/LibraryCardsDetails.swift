//
//  Json4Swift_Base.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct LibraryCardsDetails: Mappable {
    
    var cards : [LibraryCard]?
    var banks : [Bank]?
    var loyaltyCards : [Loyalty]?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        cards <- map["PaymentCardLists"]
        banks <- map["BankDetailsLists"]
        loyaltyCards <- map["LoyaltyCardList"]
        
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
}
