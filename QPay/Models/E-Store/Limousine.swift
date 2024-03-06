//
//  Limousine.swift
//  QPay
//
//  Created by Mohammed Hamad on 24/10/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Limousine: Mappable, Equatable {
    
    var id: Int?
    var companyName: String?
    var mobile: String?
    var email: String?
    var website: String?
    var location: String?
    var typeID: String?
    var type: String?
    var rating: Double?
    var isItemAdded: Bool?
    var isFeatured: Bool?
    var image: String?
    
    var _id: Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _companyName: String {
        get {
            return companyName ?? ""
        }
    }
    
    var _mobile: String {
        get {
            return mobile ?? ""
        }
    }
    
    var _email: String {
        get {
            return email ?? ""
        }
    }
    var _website: String {
        get {
            return website ?? ""
        }
    }
    
    var _location: String {
        get {
            return location ?? ""
        }
    }
    
    var _typeID: String {
        get {
            return typeID ?? ""
        }
    }
    
    var _type: String {
        get {
            return type ?? ""
        }
    }
    
    var _rating: Double {
        get {
            return rating ?? 0.0
        }
    }
    
    var _isItemAdded: Bool {
        get {
            return isItemAdded ?? false
        }
    }
    
    var _isFeatured: Bool {
        get {
            return isFeatured ?? false
        }
    }
    
    var _image: String {
        get {
            return self.image ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["ID"]
        self.companyName <- map["CompanyName"]
        self.mobile <- map["ContactNumber"]
        self.email <- map["Email"]
        self.website <- map["Website"]
        self.location <- map["Location"]
        self.typeID <- map["ContactTypeID"]
        self.type <- map["ContactType"]
        self.rating <- map["Rating"]
        self.isItemAdded <- map["IsItemAdded"]
        self.isFeatured <- map["IsFetured"]
        self.image <- map["ImageLocation"]
    }
}
