//
//  
//  LoginResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct LoginResponse : Codable, Mappable {
    
    var id: String?
    var email: String?
    var token: String?
    var refreshToken: String?
    var refreshTokenExpiryTime: String?
    var phoneNumber: String?
    var countryCode: String?
    var name: String?
    var userImage: String?
    var storeId: String?
    
    var _id: String {
        get {
            return self.id ?? ""
        }
    }
    
    var _email: String {
        get {
            return self.email ?? ""
        }
    }
    
    var _token: String {
        get {
            return self.token ?? ""
        }
    }
    
    var _refreshToken: String {
        get {
            return self.refreshToken ?? ""
        }
    }
    
    var _refreshTokenExpiryTime: String {
        get {
            return self.refreshTokenExpiryTime ?? ""
        }
    }
    
    var _phoneNumber: String {
        get {
            return self.phoneNumber ?? ""
        }
    }
    
    var _countryCode: String {
        get {
            return self.countryCode ?? ""
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _userImage: String {
        get {
            return self.userImage ?? ""
        }
    }
    
    var _storeId: String {
        get {
            return self.storeId ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case email = "email"
        case token = "token"
        case refreshToken = "refreshToken"
        case refreshTokenExpiryTime = "refreshTokenExpiryTime"
        case phoneNumber = "phoneNumber"
        case countryCode = "countryCode"
        case name = "name"
        case userImage = "userImage"
        case storeId = "storeId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.token = try values.decodeIfPresent(String.self, forKey: .token)
        self.refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        self.refreshTokenExpiryTime = try values.decodeIfPresent(String.self, forKey: .refreshTokenExpiryTime)
        self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
        self.userImage = try values.decodeIfPresent(String.self, forKey: .userImage)
        self.storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.email <- map["email"]
        self.token <- map["token"]
        self.refreshToken <- map["refreshToken"]
        self.refreshTokenExpiryTime <- map["refreshTokenExpiryTime"]
        self.phoneNumber <- map["phoneNumber"]
        self.countryCode <- map["countryCode"]
        self.name <- map["name"]
        self.userImage <- map["userImage"]
        self.storeId <- map["storeId"]
    }
}
