//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Parking : Mappable {
    
    var id : Int?
    var name : String?
    var address : String?
    var nameAr : String?
    var addressAr : String?
    var status : Bool?
    var isShow : Bool?
    var createdBy : String?
    var updateDate : String?
    var imagURL : String?

    init?(map: Map) {

    }
    
    init() {
        
    }

    mutating func mapping(map: Map) {

        id <- map["ID"]
        name <- map["Name"]
        address <- map["Address"]
        nameAr <- map["NameAr"]
        addressAr <- map["AddressAr"]
        status <- map["Status"]
        isShow <- map["IsShow"]
        createdBy <- map["CreatedBy"]
        updateDate <- map["UpdateDate"]
        imagURL <- map["ImagURL"]
    }
}

