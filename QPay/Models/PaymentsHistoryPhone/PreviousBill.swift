//
//  PreviousBill.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PreviousBill : Mappable {
    var bill : Double?
    var amounttobePaid : Double?
    var date : String?
    var status : String?
    var billNumber : String?
    
    var _bill : Double {
        get {
            return self.bill ?? 0
        }
    }
    
    var _amounttobePaid : Double {
        get {
            return self.amounttobePaid ?? 0
        }
    }
    
    var _date : String {
        get {
            return self.date ?? ""
        }
    }
    
    var _status : String {
        get {
            return self.status ?? ""
        }
    }
    
    var _billNumber : String {
        get {
            return self.billNumber ?? ""
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        bill           <- map["Bill"]
        amounttobePaid <- map["AmounttobePaid"]
        date           <- map["Date"]
        status         <- map["Status"]
        billNumber     <- map["BillNumber"]
    }
    
}
