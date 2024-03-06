//
//  ParkingTicket.swift
//  QPay
//
//  Created by Mohammed Hamad on 26/08/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct ParkingTicket: Mappable {
    
    var number: String?
    var timeIn: String?
    var timeOut: String?
    var totalTime: String?
    var amount: Double?
    var serviceCharge: Double?
    var totalAmount: Double?
    var id: String?
    var requestID: String?
    var plateNo: String?
    var userHasBalance: Bool?
    var smsEditorEnable: Bool?
    var accessToken: String?
    var verificationID: String?
    var success: Bool?
    var code: String?
    var message: String?
    var errors: [String]?
    
    var _number: String {
        get {
            return number ?? ""
        }
    }
    
    var _timeIn: String {
        get {
            return timeIn ?? ""
        }
    }
    
    var _timeOut: String {
        get {
            return timeOut ?? ""
        }
    }
    
    var _totalTime: String {
        get {
            return totalTime ?? ""
        }
    }
    
    var _amount: Double {
        get {
            return amount ?? 0.0
        }
    }
    
    var _serviceCharge: Double {
        get {
            return serviceCharge ?? 0.0
        }
    }
    
    var _totalAmount: Double {
        get {
            return totalAmount ?? 0.0
        }
    }
    
    var _id: String {
        get {
            return id ?? ""
        }
    }
    
    var _requestID: String {
        get {
            return requestID ?? ""
        }
    }
    
    var _plateNo: String {
        get {
            return plateNo ?? ""
        }
    }
    
    var _userHasBalance: Bool {
        get {
            return userHasBalance ?? false
        }
    }
    
    var _smsEditorEnable: Bool {
        get {
            return smsEditorEnable ?? false
        }
    }
    
    var _accessToken: String {
        get {
            return accessToken ?? ""
        }
    }
    
    var _verificationID: String {
        get {
            return verificationID ?? ""
        }
    }
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.number <- map["ParkingTicketNumber"]
        self.timeIn <- map["TimeIn"]
        self.timeOut <- map["TimeOut"]
        self.totalTime <- map["TotalTime"]
        self.amount <- map["Amount"]
        self.serviceCharge <- map["ServiceCharge"]
        self.totalAmount <- map["TotalAmount"]
        self.id <- map["ID"]
        self.requestID <- map["RequestID"]
        self.plateNo <- map["PlateNo"]
        self.userHasBalance <- map["UserHasBalance"]
        self.smsEditorEnable <- map["SmsEditorEnable"]
        self.accessToken <- map["AccessToken"]
        self.verificationID <- map["VerificationID"]
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
