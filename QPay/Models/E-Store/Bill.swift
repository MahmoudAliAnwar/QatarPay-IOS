//
//  Bill.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Bill : Mappable {
    
    var name : String?
    var id : Int?
    var amount : Double?
    var count : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        name   <- map["Name"]
        id     <- map["ID"]
        amount <- map["Amount"]
        count  <- map["Count"]
    }

}
