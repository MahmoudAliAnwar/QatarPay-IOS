//
//  DineTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct DineTab : Mappable , Codable , Equatable {
    
    var dineName : String?
    var dineID   : Int?
    var isActive : Bool?
    
    var _dineName : String {
        get {
          return dineName ?? ""
        }
    }
    
    var _dineID : Int {
        get {
          return dineID ?? 0
        }
    }
    
    var _isActive : Bool {
        get {
          return isActive ?? false
        }
    }
        
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        dineName <- map["DineBuisnessCategory"]
        dineID   <- map["DineBuisnessCategoryID"]
        isActive <- map["IsActive"]
    }
    
}
