//
//  PaymentRequestDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/07/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

struct PaymentRequestDetails: Codable {
    
    var paymentRequestID   : String = ""
    var operatorID         : Int = 0
    var groupID            : Int = 0
    var number             : String = ""
    var isFullAmount       : Bool = false
    var isRecurringPayment : Bool = false
    var isPartialAmount    : Bool = false
    var amount             : Double = 0.0
    var platForm           : String = "IOS"
    var scheduledDate      : String = ""
    
    enum CodingKeys: String, CodingKey {
        case paymentRequestID = "paymentRequestID"
        case operatorID = "operatorID"
        case groupID = "groupID"
        case number = "number"
        case isFullAmount = "isFullAmount"
        case isRecurringPayment = "isRecurringPayment"
        case isPartialAmount = "isPartialAmount"
        case amount = "amount"
        case platForm = "platForm"
        case scheduledDate = "scheduledDate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        paymentRequestID = try container.decodeIfPresent(String.self, forKey: .paymentRequestID) ?? ""
        operatorID = try container.decodeIfPresent(Int.self, forKey: .operatorID) ?? 0
        groupID = try container.decodeIfPresent(Int.self, forKey: .groupID) ?? 0
        number = try container.decodeIfPresent(String.self, forKey: .number) ?? ""
        isFullAmount = try container.decodeIfPresent(Bool.self, forKey: .isFullAmount) ?? false
        isRecurringPayment = try container.decodeIfPresent(Bool.self, forKey: .isRecurringPayment) ?? false
        isPartialAmount = try container.decodeIfPresent(Bool.self, forKey: .isPartialAmount) ?? false
        amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        platForm = try container.decodeIfPresent(String.self, forKey: .platForm) ?? ""
        scheduledDate = try container.decodeIfPresent(String.self, forKey: .scheduledDate) ?? ""
    }
    
    init() {
        
    }
}

struct PaymentRequestDetailsObject : Codable {
    
    var array : [PaymentRequestDetails] = []
    
    enum CodingKeys: String, CodingKey {
        case array = "PaymentRequest"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        array = try container.decodeIfPresent([PaymentRequestDetails].self, forKey: .array) ?? []
    }
    
    init() {
        
    }
}

struct PaymentRequestPhoneBillParams : Codable {
   var operatorID         : Int = 0
   var groupDetails       : [GroupDetails] = []
   var isFullAmount       : Bool = false
   var isRecurringPayment : Bool = false
   var isPartialAmount    : Bool = false
   var amount             : Double = 0
   var platForm           : String = "IOS"
   var scheduledDate      : String = ""
    
    enum CodingKeys: String, CodingKey {
        case operatorID = "operatorID"
        case groupDetails = "groupDetails"
        case isFullAmount = "isFullAmount"
        case isRecurringPayment = "isRecurringPayment"
        case isPartialAmount = "isPartialAmount"
        case amount = "amount"
        case platForm = "platForm"
        case scheduledDate = "scheduledDate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        operatorID = try container.decodeIfPresent(Int.self, forKey: .operatorID) ?? 0
        isFullAmount = try container.decodeIfPresent(Bool.self, forKey: .isFullAmount) ?? false
        isRecurringPayment = try container.decodeIfPresent(Bool.self, forKey: .isRecurringPayment) ?? false
        isPartialAmount = try container.decodeIfPresent(Bool.self, forKey: .isPartialAmount) ?? false
        amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        platForm = try container.decodeIfPresent(String.self, forKey: .platForm) ?? ""
        scheduledDate = try container.decodeIfPresent(String.self, forKey: .scheduledDate) ?? ""
    }
    
    init() {
        
    }
}

