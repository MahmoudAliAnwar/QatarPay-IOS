//
//  ChildCareTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChildCareTab : Mappable ,Codable  ,Equatable {
    
    var childCareName : String?
    var childCareID   : Int?
    var isActive      : Bool?
    
    var _childCareName : String {
        get {
            return childCareName ?? ""
        }
    }
    
    var _childCareID : Int {
        get {
            return childCareID ?? 0
        }
    }
    
    var _isActive : Bool {
        get {
            return isActive ?? false
            
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
        childCareName <- map["NurseryBuisnessCategory"]
        childCareID   <- map["NurseryBuisnessCategoryID"]
        isActive      <- map["IsActive"]
    }
    
}
