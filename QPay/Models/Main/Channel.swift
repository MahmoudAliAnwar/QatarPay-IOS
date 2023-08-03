//
//  Channel.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/07/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Channel: Mappable {
    
    var id: Int?
    var name: String?
    var imageLocation: String?
    
    var _id: Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _imageLocation: String {
        get {
            return self.imageLocation ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["ID"]
        self.name <- map["ChannelName"]
        self.imageLocation <- map["ImageLocation"]
    }
}
