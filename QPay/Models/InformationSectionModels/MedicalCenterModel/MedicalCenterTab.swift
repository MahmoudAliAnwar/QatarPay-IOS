//
//  MedicalCenterTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct MedicalCenterTab : Mappable , Codable , Equatable {
    
    var clinicsName : String?
    var clinicsID   : Int?
    var isActive    : Bool?
    
    var _clinicsName : String {
        get {
            return clinicsName ?? ""
        }
    }
    
    var _clinicsID : Int {
        get {
            return clinicsID ?? 0
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
        
        clinicsName <- map["ClinicsBuisnessCategory"]
        clinicsID   <- map["ClinicsBuisnessCategoryID"]
        isActive    <- map["IsActive"]
    }
    
}
