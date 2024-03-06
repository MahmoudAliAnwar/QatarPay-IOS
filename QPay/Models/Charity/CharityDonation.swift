//
//  
//  CharityDonation.swift
//  QPay
//
//  Created by Mohammed Hamad on 19/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct CharityDonation : Codable, Mappable {
    
    var id: Int?
    var name: String?
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
    
    var _isActive: Bool {
        get {
            return self.isActive ?? false
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "DonationID"
        case name = "DonationName"
        case isActive = "IsActive"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["DonationID"]
        self.name <- map["DonationName"]
        self.isActive <- map["IsActive"]
    }
}
