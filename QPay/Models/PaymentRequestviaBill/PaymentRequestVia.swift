//
//  PaymentRequestviaPhoneBill.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct PaymentRequestVia : Mappable {
    
    var recurringRequests : [RecurringRequests]?
    var scheduleRequests  : [ScheduleRequests]?
    var success           : Bool?
    var code              : String?
    var message           : String?
    var errors            : [String]?
    
    var _recurringRequests : [RecurringRequests] {
        get {
            return recurringRequests ?? []
        }
    }
    
    var _scheduleRequests  : [ScheduleRequests] {
        get {
            return scheduleRequests ?? []
        }
    }
    
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
        
        recurringRequests <- map["RecurringRequests_List"]
        scheduleRequests <- map["ScheduleRequests_List"]
        success <- map["success"]
        code <- map["code"]
        message <- map["message"]
        errors <- map["errors"]
    }
    
}
