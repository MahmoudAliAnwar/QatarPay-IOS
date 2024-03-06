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

struct Group : Mappable {

    var id : Int?
    var name : String?
    var description : String?
    var isActive : Bool?
    var code : String?

    var _id : Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _name : String {
        get {
            return self.name ?? ""
        }
    }
    
    var _description : String {
        get {
            return self.description ?? ""
        }
    }
    
    var _isActive : Bool {
        get {
            return self.isActive ?? false
        }
    }
    
    var _code : String {
        get {
            return self.code ?? ""
        }
    }
    
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["GroupID"]
        name <- map["GroupName"]
        description <- map["GroupDescription"]
        isActive <- map["IsActive"]
        code <- map["GroupCode"]
    }
}

