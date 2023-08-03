//
//  StocksNews.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct StocksNews : Mappable , Codable {
    
    var stockNewsTitle       : String?
    var stockNewsDescription : String?
    var stockNewsDate        : String?
    
    var _stockNewsTitle : String {
        get {
            return stockNewsTitle ?? ""
        }
    }
    
    var _stockNewsDescription : String {
        get {
            return stockNewsDescription ?? ""
        }
    }
    
    var _stockNewsDate : String {
        get {
            return stockNewsDate ?? ""
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        stockNewsTitle       <- map["StockNewsTitle"]
        stockNewsDescription <- map["StockNewsDescription"]
        stockNewsDate        <- map["StockNewsDate"]
    }
    
}
