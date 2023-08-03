//
//  Service.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Service : Mappable {
    
    var id : Int?
    var name : String?
    var location : String?
    var count : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["ServiceID"]
        name <- map["ServiceName"]
        location <- map["ImageLocation"]
        count <- map["Count"]
    }
}
