//
//  InsurancesTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct InsurancesTab : Mappable , Codable , Equatable {
    
    var insuranceName : String?
    var insuranceID   : Int?
    var isActive      : Bool?
    
    var _insuranceName : String{
        get {
            return insuranceName ?? ""
        }
    }
    
    var _insuranceID : Int{
        get {
            return insuranceID ?? 0
        }
    }
    
    var _isActive : Bool{
        get {
            return isActive ?? false
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        insuranceName  <- map["InsuranceBuisnessCategory"]
        insuranceID    <- map["InsuranceBuisnessCategoryID"]
        isActive       <- map["IsActive"]
    }
    
}
