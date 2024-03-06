//
//  HotelTab.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct HotelTab : Mappable , Codable {
    
    var hotelName : String?
    var hotelID   : Int?
    var isActive  : Bool?
    
    var _hotelName : String{
        get {
            return hotelName ?? ""
        }
    }
    
    var _hotelID : Int{
        get {
            return hotelID ?? 0
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
        
        hotelName <- map["HotelBuisnessCategory"]
        hotelID   <- map["HotelBuisnessCategoryID"]
        isActive  <- map["IsActive"]
    }
}
