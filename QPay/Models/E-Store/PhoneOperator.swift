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

struct PhoneOperator : Mappable {
    
    var id : Int?
    var text : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["ID"]
        text <- map["Text"]
    }

}
