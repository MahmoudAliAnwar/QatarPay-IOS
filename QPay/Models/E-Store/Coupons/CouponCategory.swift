//
//  
//  CouponCategory.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct CouponCategory : Mappable, Equatable {
    
    var id: Int?
    var name: String?
    var icon: String?
    
    var _id: Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _name: String {
        get {
            return name ?? ""
        }
    }
    
    var _icon: String {
        get {
            return icon ?? ""
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["Id"]
        self.name <- map["Name"]
        self.icon <- map["CategoryImageLocation"]
    }
}
