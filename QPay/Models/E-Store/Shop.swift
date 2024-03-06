//
//  Shop.swift
//  QPay
//
//  Created by Dev. Mohmd on 9/17/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Shop: Mappable {
    
    var id: Int?
    var name: String?
    var nameAR: String?
    var description: String?
    var descriptionAR: String?
    var isActive: Bool?
    var logo: String?
    var banner: String?
    var creationDate: String?
    var products: [Product]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["ShopID"]
        name <- map["ShopName"]
        nameAR <- map["ShopNameAR"]
        description <- map["ShopDescription"]
        descriptionAR <- map["ShopDescriptionAR"]
        isActive <- map["IsActive"]
        logo <- map["ShopImage"]
        banner <- map["ShopBanner"]
        creationDate <- map["CreationDate"]
        products <- map["ProductList"]
    }
}
