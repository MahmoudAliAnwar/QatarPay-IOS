//
//  MyStocksGroupDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct MyStocksGroupDetails : Mappable {
    var groupName : String?
    var stockList : [MyStockList]?
    
    var isOpened: Bool = false
    
    var _groupName  : String {
        get {
            return groupName ?? ""
        }
    }
    
    var _stockList : [MyStockList] {
        get {
            return stockList ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        groupName  <- map["GroupName"]
        stockList  <- map["StockLists"]
    }
}
