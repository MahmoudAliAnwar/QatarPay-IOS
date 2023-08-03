//
//  LimousineTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct LimousineTab : Mappable, Codable, Equatable {
    
    var ojraBuisnessCategory : String?
    var isActive             : Bool?
    var iD                   : Int?
    
    var _id: Int {
        get {
            return self.iD ?? 0
        }
    }
    
    var _ojraBuisnessCategory : String {
        get {
            return ojraBuisnessCategory ?? ""
        }
    }
    
    var _isActive : Bool {
        get {
            return isActive ?? true
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        ojraBuisnessCategory <- map["OjraBuisnessCategory"]
        isActive             <- map["IsActive"]
        iD                   <- map["ID"]
    }
}
