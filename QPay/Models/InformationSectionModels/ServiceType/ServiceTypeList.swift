//
//  ChildCareServiceTypeList.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServiceType : Mappable {
    
    var serviceTypeDetails      : [ServiceTypeDetails]?
    var buisnessCategoryDetails : [BuisnessCategoryDetails]?
    var locDelivDetails         : [LocDelivDetails]?
    
    var _serviceTypeDetails      : [ServiceTypeDetails]{
        get{
            return serviceTypeDetails ?? []
        }
    }
    
    var _buisnessCategoryDetails : [BuisnessCategoryDetails]{
        get{
            return buisnessCategoryDetails ?? []
        }
    }
    
    var _locDelivDetails: [LocDelivDetails]{
        get{
            return locDelivDetails ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        serviceTypeDetails      <- map["ServiceTypeDetails"]
        buisnessCategoryDetails <- map["BuisnessCategoryDetails"]
        locDelivDetails         <- map["Loc_DelivDetails"]
    }
    
}
