//
//  
//  CreateAccountResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 09/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct CreateAccountResponse : Codable, Mappable {
    
    var id: String?
    
    var _id: String {
        get {
            return self.id ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
    }
}
