//
//  QaterSchoolTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct QaterSchoolTab : Mappable ,Codable, Equatable {
    
    var schoolName : String?
    var schoolID   : Int?
    var isActive   : Bool?
    
    var _schoolName : String {
        get {
            return schoolName ?? ""
        }
    }
    
    var _schoolID   : Int {
        get {
            return schoolID ?? 0
        }
    }
    
    var _isActive   : Bool {
        get {
            return isActive ?? false
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        schoolName <- map["SchoolBuisnessCategory"]
        schoolID   <- map["SchoolBuisnessCategoryID"]
        isActive   <- map["IsActive"]
    }
    
}
