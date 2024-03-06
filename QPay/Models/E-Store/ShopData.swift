//
//  ShopData.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/16/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ShopData : Mappable {
    
    var id : Int?
    var name : String?
    var description : String?
    var logo : String?
    var code : String?
    var products : [Product]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        
        id <- map["ShopID"]
        name <- map["ShopName"]
        description <- map["ShopDescription"]
        logo <- map["ShopLogo"]
        code <- map["ShopCode"]
        products <- map["ProductList"]
    }

}
