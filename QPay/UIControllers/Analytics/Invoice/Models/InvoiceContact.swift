//
//  
//  InvoiceContact.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct InvoiceContact : Codable, Mappable {
    
    var id: Int?
    var name: String?
    var company: String?
    var address: String?
    var email: String?
    var mobile: String?
    var isActive: Bool?
    var website: String?
    var twitter: String?
    var facebook: String?
    var instagram: String?
    var notes: String?
    var relative: String?
    var userID: Int?
    
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
    
    var _company: String {
        get {
            return company ?? ""
        }
    }
    
    var _address: String {
        get {
            return address ?? ""
        }
    }
    
    var _email: String {
        get {
            return email ?? ""
        }
    }
    
    var _mobile: String {
        get {
            return mobile ?? ""
        }
    }
    
    var _isActive: Bool {
        get {
            return isActive ?? false
        }
    }
    
    var _website: String {
        get {
            return website ?? ""
        }
    }
    
    var _twitter: String {
        get {
            return twitter ?? ""
        }
    }
    
    var _facebook: String {
        get {
            return facebook ?? ""
        }
    }
    
    var _instagram: String {
        get {
            return instagram ?? ""
        }
    }
    
    var _notes: String {
        get {
            return notes ?? ""
        }
    }
    
    var _relative: String {
        get {
            return relative ?? ""
        }
    }
    
    var _userID: Int {
        get {
            return userID ?? 0
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case company = "Company"
        case address = "Address"
        case email = "Email"
        case mobile = "Mobile"
        case isActive = "IsActive"
        case website = "Website"
        case twitter = "Twitter"
        case facebook = "Facebook"
        case instagram = "Instagram"
        case notes = "Notes"
        case relative = "Relative"
        case userID = "UserID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.company = try values.decodeIfPresent(String.self, forKey: .company)
        self.address = try values.decodeIfPresent(String.self, forKey: .address)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        self.isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        self.website = try values.decodeIfPresent(String.self, forKey: .website)
        self.twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
        self.facebook = try values.decodeIfPresent(String.self, forKey: .facebook)
        self.instagram = try values.decodeIfPresent(String.self, forKey: .instagram)
        self.notes = try values.decodeIfPresent(String.self, forKey: .notes)
        self.relative = try values.decodeIfPresent(String.self, forKey: .relative)
        self.userID = try values.decodeIfPresent(Int.self, forKey: .userID)
    }
    
    init() {
        
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["ID"]
        self.name <- map["Name"]
        self.company <- map["Company"]
        self.address <- map["Address"]
        self.email <- map["Email"]
        self.mobile <- map["Mobile"]
        self.isActive <- map["IsActive"]
        self.website <- map["Website"]
        self.twitter <- map["Twitter"]
        self.facebook <- map["Facebook"]
        self.instagram <- map["Instagram"]
        self.notes <- map["Notes"]
        self.relative <- map["Relative"]
        self.userID <- map["UserID"]
    }
}
