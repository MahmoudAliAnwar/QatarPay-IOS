//
//  Banners.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Banner : Mappable {
    
    var id : Int?
    var location : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["BannerID"]
        location <- map["BannerLocation"]
    }

}
