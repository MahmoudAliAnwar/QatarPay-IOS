//
//  
//  CharityType.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct CharityType : Codable, Mappable {
    
    var id: Int?
    var name: String?
    var nameAr: String?
    var image: String?
    var isActive: Bool?
    
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
    
    var _nameAr: String {
        get {
            return self.nameAr ?? ""
        }
    }
    
    var _image: String {
        get {
            return self.image ?? ""
        }
    }
    
    var _isActive: Bool {
        get {
            return self.isActive ?? false
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "CharityID"
        case name = "CharityName"
        case nameAr = "CharityArabicName"
        case image = "CharityImageLocation"
        case isActive = "IsActive"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.nameAr = try values.decodeIfPresent(String.self, forKey: .nameAr)
        self.image = try values.decodeIfPresent(String.self, forKey: .image)
        self.isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["CharityID"]
        self.name <- map["CharityName"]
        self.nameAr <- map["CharityArabicName"]
        self.image <- map["CharityImageLocation"]
        self.isActive <- map["IsActive"]
    }
}
