//
//  
//  InvoiceUser.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct InvoiceUser : Mappable, Codable {
    
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var userName: String?
    var name: String?
    var role: String?
    var ImageLocation: String?
    var email: String?
    
    var _access_token: String {
        get {
            return access_token ?? ""
        }
    }
    
    var _token_type: String {
        get {
            return token_type ?? ""
        }
    }
    
    var _expires_in: Int {
        get {
            return expires_in ?? 0
        }
    }
    
    var _userName: String {
        get {
            return userName ?? ""
        }
    }
    
    var _name: String {
        get {
            return name ?? ""
        }
    }
    
    var _role: String {
        get {
            return role ?? ""
        }
    }
    
    var _ImageLocation: String {
        get {
            return ImageLocation ?? ""
        }
    }
    
    var _email: String {
        get {
            return email ?? ""
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.access_token <- map["access_token"]
        self.token_type <- map["token_type"]
        self.userName <- map["userName"]
        self.expires_in <- map["expires_in"]
        self.name <- map["Name"]
        self.role <- map["Role"]
        self.ImageLocation <- map["ImageLocation"]
        self.email <- map["Email"]
    }
}
