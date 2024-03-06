//
//  Dashboard.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/6/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct Dashboard : Mappable {
    
    var balance : Double?
    var banners : [Banner]?
    var currentBills : String?
    var categories : [ServiceCategory]?
    var bills : [Bill]?
    var totalCollected : Double?
    var totalOutstanding : Double?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        self.balance <- map["Balance"]
        self.banners <- map["BannersList"]
        self.currentBills <- map["CurrentBills"]
        self.categories <- map["ServiceList"]
        self.bills <- map["BillDetails"]
        self.totalCollected <- map["TotalCollected"]
        self.totalOutstanding <- map["TotalOutstanding"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
