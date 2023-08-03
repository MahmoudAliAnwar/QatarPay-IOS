//
//  ChildCareServiceTypeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ServiceTypeDetails : Mappable {
    
    var service              : String?
    var serviceImageLocation : String?
    var serviceID            : Int?
    
    var _service : String{
        get {
            return service ?? ""
        }
    }
    var _serviceImageLocation : String{
        get {
            return serviceImageLocation ?? ""
        }
    }
    var _serviceID : Int{
        get {
            return serviceID ?? 0
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        service              <- map["Service"]
        serviceImageLocation <- map["ServiceImageLocation"]
        serviceID            <- map["ServiceID"]
    }
    
}
