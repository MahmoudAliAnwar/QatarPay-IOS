//
//  BaseResponse.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseObjectResponse<T: Mappable>: Mappable {
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var object: T?
    
    var _success : Bool {
        get {
            return success ?? false
        }
    }
    
    var _code : String {
        get {
            return code ?? ""
        }
    }
    
    var _message : String {
        get {
            return message ?? ""
        }
    }
    
    var _errors : [String] {
        get {
            return errors ?? []
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
                
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
        
        let key = self.getObjectKey()
        if map.JSON.keys.contains(key) {
            self.object <- map[key]
        }
    }
    
    private func getObjectKey() -> String {
        var name = String(describing: T.self)
        
        if name.contains("Profile") {
            return "User"
            
        }else if name.contains("PhoneGroup") {
            return "GroupList"
            
        }else if name.contains("Order") {
            name += "Detail"
            
        }else if name.contains("Beneficiary") {
            name += "Detail"
            
        }else if name.contains("MSISDN") {
            name += "Detail"
            
        }else if name.contains("InvoiceAppDetails") {
            name = "InvoiceInfo"
        }
        return name
    }
}
