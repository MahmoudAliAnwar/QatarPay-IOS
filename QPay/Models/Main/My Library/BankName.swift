//
//  BankName.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper
import UIKit

struct BankName : Mappable {
    
    var id : Int?
    var text : String?
    
    var _id : Int {
        get {
            return id ?? 0
        }
    }
    
    var _text : String {
        get {
            return text ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["ID"]
        text <- map["Text"]
    }
}
