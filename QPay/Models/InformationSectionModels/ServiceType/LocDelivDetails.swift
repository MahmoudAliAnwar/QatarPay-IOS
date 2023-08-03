//
//  LocDelivDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct LocDelivDetails : Mappable {
    
    var local_Delv_Comp : String?
    var appLink         : String?
    var local_DelvID    : Int?
    
    var _local_Delv_Comp : String {
        get {
            return local_Delv_Comp ?? ""
        }
    }
    var _appLink : String {
        get {
            return appLink ?? ""
        }
    }
    var _local_DelvID : Int {
        get {
            return local_DelvID ?? 0
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        local_Delv_Comp <- map["Local_Delv_Comp"]
        appLink         <- map["AppLink"]
        local_DelvID    <- map["Local_DelvID"]
    }
    
}
