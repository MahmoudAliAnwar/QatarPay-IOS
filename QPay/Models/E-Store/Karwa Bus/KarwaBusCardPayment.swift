//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct KarwaBusCardPayment: Mappable {
    
    var referenceNumber : String?
    var clientReference: String?
    var requestID : Int?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        referenceNumber <- map["ReferenceNumber"]
        clientReference <- map["ClientReference"]
        requestID <- map["RequestID"]
        
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
}
