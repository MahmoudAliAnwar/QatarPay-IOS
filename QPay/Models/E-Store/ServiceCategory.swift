//
//  Category.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServiceCategory : Mappable {
    
    var categoryID : Int?
    var categoryName : String?
    var services : [Service]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        categoryID <- map["CategoryID"]
        categoryName <- map["CategoryName"]
        services <- map["ServiceList"]
    }

}
