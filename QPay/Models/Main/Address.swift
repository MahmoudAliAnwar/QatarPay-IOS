//
//  Address.swift
//  QPay
//
//  Created by Mohammed Hamad on 04/05/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Address: Mappable, Equatable {
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs._streetName == rhs._streetName &&
            lhs._buildingNumber == rhs._buildingNumber &&
            lhs._name == rhs._name
    }
    
    
    var id: Int?
    var zone: String?
    var name: String?
    var buildingNumber: String?
    var streetNumber: String?
    var streetName: String?
    var city: String?
    var country: String?
    var poBox: String?
    var groupID: Int?
    var groupName: String?
    var isDefaultAddress: Bool?
    var latitude: String?
    var longitude: String?
    
    var _id: Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _zone: String {
        get {
            return self.zone ?? ""
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _buildingNumber: String {
        get {
            return self.buildingNumber ?? ""
        }
    }
    
    var _streetNumber: String {
        get {
            return self.streetNumber ?? ""
        }
    }
    
    var _streetName: String {
        get {
            return self.streetName ?? ""
        }
    }
    
    var _city: String {
        get {
            return self.city ?? ""
        }
    }
    
    var _country: String {
        get {
            return self.country ?? ""
        }
    }
    
    var _poBox: String {
        get {
            return self.poBox ?? ""
        }
    }
    
    var _groupID: Int {
        get {
            return self.groupID ?? 0
        }
    }
    
    var _groupName: String {
        get {
            return self.groupName ?? ""
        }
    }
    
    var _isDefaultAddress: Bool {
        get {
            return self.isDefaultAddress ?? false
        }
    }
    
    var _latitude: String {
        get {
            return self.latitude ?? ""
        }
    }
    
    var _longitude: String {
        get {
            return self.longitude ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        self.map = map
    }
    
    var map: Map?
    
    mutating func mapping(map: Map) {
        
        self.id <- map["AddressID"]
        self.zone <- map["Zone"]
        self.name <- map["AddressName"]
        self.buildingNumber <- map["BuildingNumber"]
        self.streetNumber <- map["Street"]
        self.streetName <- map["Address"]
        self.city <- map["CIty"]
        self.country <- map["Country"]
        self.poBox <- map["PoBox"]
        self.groupID <- map["GroupID"]
        self.groupName <- map["GroupName"]
        self.isDefaultAddress <- map["IsDefaultAddress"]
        self.latitude <- map["Latitude"]
        self.longitude <- map["Longitude"]
    }
}
