//
//  RecurringRequests.swift
//  QPay
//
//  Created by Mohammed Hamad on 18/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct RecurringRequests : Mappable {
     
    var paymentRequestID   : String?
    var groupName          : String?
    var isFullAmount       : Bool?
    var isRecurringPayment : Bool?
    var isPartialAmount    : Bool?
    var amount             : Double?
    var scheduledDate      : String?
    var number             : String?
    var paymentStatus      : String?
    
    var _paymentRequestID : String {
        get {
            return paymentRequestID ?? ""
        }
    }
    
    var _groupName : String {
        get {
            return groupName ?? ""
        }
    }
    
    var _isFullAmount : Bool {
        get {
            return isFullAmount ?? false
        }
    }
    
    var _isRecurringPayment : Bool {
        get {
            return isRecurringPayment ?? false
        }
    }
    
    var _isPartialAmount : Bool {
        get {
            return isPartialAmount ?? false
        }
    }
    
    var _amount : Double {
        get {
            return amount ?? 0
        }
    }
    
    var _scheduledDate : String {
        get {
            return scheduledDate ?? ""
        }
    }
    
    var _number : String {
        get {
            return number ?? ""
        }
    }
    
    var _paymentStatus : String {
        get {
            return paymentStatus ?? ""
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        paymentRequestID   <- map["PaymentRequestID"]
        groupName          <- map["GroupName"]
        isFullAmount       <- map["IsFullAmount"]
        isRecurringPayment <- map["IsRecurringPayment"]
        isPartialAmount    <- map["IsPartialAmount"]
        amount             <- map["Amount"]
        scheduledDate      <- map["ScheduledDate"]
        number             <- map["Number"]
        paymentStatus      <- map["PaymentStatus"]
    }
    
}
