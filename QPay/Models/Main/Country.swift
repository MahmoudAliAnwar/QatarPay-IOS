//
//  Country.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/21/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Country : Mappable {
    
    var id : Int?
    var name : String?
    var code : String?
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["CountryID"]
        self.name <- map["Country"]
        self.code <- map["CountryCode"]
    }
}
