//
//  
//  CreateOrderResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit

struct CreateOrderResponse : Codable {
    
    var name: String?
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
