//
//  TopupCountry.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct TopupCountry : Mappable {
    
    var id : Int?
    var name : String?
    var code : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["CountryID"]
        name <- map["Country"]
        code <- map["CountryCode"]
    }
}

