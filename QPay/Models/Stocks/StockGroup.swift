//
//  
//  StockGroup.swift
//  QPay
//
//  Created by Mohammed Hamad on 14/04/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct StockGroup : Mappable {
    
    var id: Int?
    var name: String?
    var description: String?
    var isActive: Bool?
    var code: String?
    
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
    
    var _description: String {
        get {
            return description ?? ""
        }
    }
    
    var _isActive: Bool {
        get {
            return isActive ?? false
        }
    }
    
    var _code: String {
        get {
            return code ?? ""
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["GroupID"]
        self.name <- map["GroupName"]
        self.description <- map["GroupDescription"]
        self.isActive <- map["IsActive"]
        self.code <- map["GroupCode"]
    }
}
