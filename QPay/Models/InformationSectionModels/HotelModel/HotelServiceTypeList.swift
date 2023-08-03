//
//  HotelServiceTypeList.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct HotelServiceTypeList     : Mappable {
    
    var serviceTypeDetails      : [ServiceTypeDetails]?
    var buisnessCategoryDetails : [BuisnessCategoryDetails]?
    
    var _serviceTypeDetails : [ServiceTypeDetails]{
        get {
            return serviceTypeDetails ?? []
        }
    }
    
    var _buisnessCategoryDetails : [BuisnessCategoryDetails]{
        get {
            return buisnessCategoryDetails ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        serviceTypeDetails      <- map["ServiceTypeDetails"]
        buisnessCategoryDetails <- map["BuisnessCategoryDetails"]
    }
    
}
