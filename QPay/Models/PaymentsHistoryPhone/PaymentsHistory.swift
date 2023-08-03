//
//  PhonePaymentsHistory.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaymentsHistory : Mappable {
    var date : String?
    var current_bill : Double?
    var previousBills : [PreviousBill]?
    
    var _date : String {
        get {
            return date ?? ""
        }
    }
    
    var _current_bill : Double {
        get {
            return current_bill ?? 0
        }
    }
    
    var _previousBills : [PreviousBill] {
        get {
            return previousBills ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        date         <- map["Date"]
        current_bill <- map["current_bill"]
        previousBills <- map["previous_bill_list"]
    }
    
}
