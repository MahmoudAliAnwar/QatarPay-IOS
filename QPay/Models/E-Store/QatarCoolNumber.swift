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

struct QatarCoolNumber : Mappable, SectionModelProtocol {

    var numberID : Int?
    var number : String?
    var qid : String?
    var Operator : String?
    var operatorID : Int?
    var subscriberName : String?
    var isActive : Bool?
    var groupName : String?
    var groupID : Int?
    var currentBill : Double?
    
    var isSelected: Bool = false
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _groupID : Int {
        get {
            return self.groupID ?? 0
        }
    }
    
    var _numberID : Int {
        get {
            return self.numberID ?? 0
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

        self.numberID <- map["QatarCoolNumberID"]
        self.number <- map["QatarCoolNumber"]
        self.qid <- map["QID"]
        self.Operator <- map["Operator"]
        self.operatorID <- map["OperatorID"]
        self.subscriberName <- map["SubscriberName"]
        self.isActive <- map["IsActive"]
        self.groupName <- map["GroupName"]
        self.groupID <- map["GroupID"]
        self.currentBill <- map["CurrentBill"]
    }
}
