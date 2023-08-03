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

struct PhoneNumber : Mappable, SectionModelProtocol {

    var numberID : Int?
    var number : String?
    var QID : String?
    var Operator : String?
    var operatorID : Int?
    var subscriberName : String?
    var IsActive : Bool?
    var groupName : String?
    var groupID : Int?
    var currentBill : Double?
    
    var isSelected: Bool = false
    
    
    var _numberID : Int {
        get{
            return self.numberID ?? 0
        }
    }
    
    var _operatorID : Int {
        get{
            return self.operatorID ?? 0
        }
    }
    
    var _groupID : Int {
        get {
            return self.groupID ?? 0
        }
    }


    var _groupName: String {
        get {
            return self.groupName ?? ""
        }
    }
    
    var _Operator: String {
        get {
            return self.Operator ?? ""
        }
    }
    
    var _subscriberName: String {
        get {
            return self.subscriberName ?? ""
        }
    }
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _currentBill: Double {
        get {
            return self.currentBill ?? 0.0
        }
    }
    
    init(groupName: String, number: String, currentBill: Double) {
        self.groupName = groupName
        self.number = number
        self.currentBill = currentBill
    }
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        self.numberID <- map["PhoneNumberID"]
        self.number <- map["PhoneNumber"]
        self.QID <- map["QID"]
        self.Operator <- map["Operator"]
        self.operatorID <- map["OperatorID"]
        self.subscriberName <- map["SubscriberName"]
        self.IsActive <- map["IsActive"]
        self.groupName <- map["GroupName"]
        self.groupID <- map["GroupID"]
        self.currentBill <- map["CurrentBill"]
    }
}
