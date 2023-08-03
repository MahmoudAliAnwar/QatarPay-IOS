//
//  
//  StockAdv.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct StockAdv : Mappable {
    
    var id: Int?
    var path: String?
    
    var _id: Int {
        get {
            return id ?? 0
        }
    }
    
    var _path: String {
        get {
            return path ?? ""
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["ImageID"]
        self.path <- map["ImagePath"]
    }
}
