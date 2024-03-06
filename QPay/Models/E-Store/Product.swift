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

struct Product: Mappable, Codable, Equatable {
    
    var id : Int?
    var name : String?
    var nameAR : String?
    var description : String?
    var descriptionAR : String?
    var image : String?
    var price : Double?
    var isActive : Bool?
    
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
    
    var _description: String {
        get {
            return self.description ?? ""
        }
    }
    
    var _image: String {
        get {
            return self.image ?? ""
        }
    }
    
    var _price: Double {
        get {
            return self.price ?? 0.0
        }
    }
    
    init?(map: Map) {

    }
    
    init() {
        
    }
    
    init(name: String) {
        self.name = name
    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["ProductID"]
        self.name <- map["ProductName"]
        self.nameAR <- map["ProductNameAR"]
        self.description <- map["ProductDescription"]
        self.descriptionAR <- map["ProductDescriptionAR"]
        self.image <- map["productImage"]
        self.price <- map["ProductPrice"]
        self.isActive <- map["IsActive"]
    }
}
