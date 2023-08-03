//
//  GiftResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 11/04/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GiftResponse: Mappable {
    
    var stores: [GiftStore]?
    var banners: [String]?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        stores <- map["Stores"]
        banners <- map["BannerList"]
        
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
}
