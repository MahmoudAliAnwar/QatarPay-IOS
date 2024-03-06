//
//  Product.swift
//  QPay
//
//  Created by Dev. Mohmd on 8/8/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct KahramaaNumber : Mappable, SectionModelProtocol {
    
    var id : Int?
    var number : String?
    var qid : String?
    var Operator : String?
    var operatorID : Int?
    var subscriberName : String?
    var isActive : Bool?
    var groupName : String?
    var groupID : Int?
    var currentBill : Double?
    var customerName: String?
    var customerNo: String?
    var paymentDueDate: String?
    var totalOutstandingAmount: String?
    var accountNumber: String?

    
    var isSelected: Bool = false
    
    
    var _id : Int{
        get {
            return self.id ?? 0
        }
    }

    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _groupID : Int {
        get {
            return groupID ?? 0
        }
    }

    
    var _qid: String {
        get {
            return self.qid ?? ""
        }
    }
    
    var _subscriberName: String {
        get {
            return self.subscriberName ?? ""
        }
    }
    
    var _isActive: Bool {
        get {
            return self.isActive ?? false
        }
    }
    
    var _groupName: String {
        get {
            return self.groupName ?? ""
        }
    }
    
    var _currentBill: Double {
        get {
            return self.currentBill ?? 0.0
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        self.id <- map["KaharmaNumberID"]
        self.number <- map["KaharmaNumber"]
        self.qid <- map["QID"]
        self.Operator <- map["Operator"]
        self.operatorID <- map["OperatorID"]
        self.subscriberName <- map["SubscriberName"]
        self.isActive <- map["IsActive"]
        self.groupName <- map["GroupName"]
        self.groupID <- map["GroupID"]
        self.currentBill <- map["CurrentBill"]
        self.customerNo <- map["CustomerNo"]
        self.customerName <- map["CustomerName"]
        self.paymentDueDate <- map["PaymentDueDate"]
        self.totalOutstandingAmount <- map["TotalOutstandingAmount"]
        self.accountNumber <- map["AccountNumber"]
    }
}
