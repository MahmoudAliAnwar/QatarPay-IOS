//
//  Store.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GiftStore: Mappable {
    
    var id: Int?
    var name: String?
    var imageURL: String?
    var iconURL: String?
    
    var _id: Int {
        get {
            return self.id ?? -1
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _imageURL: String {
        get {
            return self.imageURL ?? ""
        }
    }
    
    var _iconURL: String {
        get {
            return self.iconURL ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["StoreID"]
        name <- map["StoreName"]
        imageURL <- map["ImageUrl"]
        iconURL <- map["IconUrl"]
    }
}





