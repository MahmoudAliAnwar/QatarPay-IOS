//
//  CatelogueImages.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct CatelogueImages : Mappable , Codable {
    var catelogue : String?
    
    var _catelogue : String {
        get {
            return catelogue ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        catelogue <- map["Catelogue"]
    }
    
}
