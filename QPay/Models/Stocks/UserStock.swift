//
//  
//  UserStock.swift
//  QPay
//
//  Created by Mohammed Hamad on 16/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct UserStock : Mappable {
    
    var id: Int?
    var name: String?
    var isActive: Bool?
    
    var _id: Int {
        get {
            return id ?? 0
        }
    }
    
    var _name: String {
        get {
            return name ?? ""
        }
    }
    
    var _isActive: Bool {
        get {
            return isActive ?? false
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["StockID"]
        self.name <- map["StockName"]
        self.isActive <- map["IsActive"]
    }
}
