//
//  Transaction.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/20/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct Transaction : Mappable, Equatable, Reusable, CachableModel {
    
    var id : Int?
    var date : String?
    var amount : Double?
    var description : String?
    var typeID : Int?
    var type : String?
    var status : String?
    var requestId : Int?
    var userid : Int?
    var username : String?
    var imgURL : String?
    var dest : String?
    var transactionDesc : String?
    var baseUrl : String?
    var locationPath : String?
    var noqs : Double?
    var destinationUserID : Int?
    var destinationUserName : String?
    var destinationImageUrl : String?
    var destinationEmail: String?
    var mobileNumber: String?
    var userType: String?
    var QPAN: String?
    var referenceNo : String?
    var refundStatus: String?
    var isAlreadyBeneficiary: String?
    
    var _date: String {
        get {
            return self.date ?? ""
        }
    }
    
    var _type: String {
        get {
            return self.type ?? ""
        }
    }
    
    var _typeID: Int {
        get {
            return self.typeID ?? 0
        }
    }
    
    var _isAlreadyBeneficiary: String {
        get {
            return self.isAlreadyBeneficiary ?? ""
        }
    }
    
    var _beneficiaryAddType: BeneficiaryAddTypes {
        get {
            return BeneficiaryAddTypes(rawValue: self._isAlreadyBeneficiary) ?? .NotAdded
        }
    }
    
    enum BeneficiaryAddTypes: String {
        case Added
        case NotAdded
    }
    
    enum UserType: String {
        case admin = "1"
        case merchant = "2"
        case user = "3"
        case support = "4"
        
        var title: String {
            get {
                switch self {
                case .admin:
                    return "Admin"
                case .merchant:
                    return "Merchant"
                case .user:
                    return "User"
                case .support:
                    return "Support"
                }
            }
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["TransactionID"]
        self.date <- map["TransactionDate"]
        self.amount <- map["Amount"]
        self.description <- map["Description"]
        self.typeID <- map["TransactionTypeID"]
        self.type <- map["TransactionType"]
        self.status <- map["TransactionStatus"]
        self.requestId <- map["RequestId"]
        self.userid <- map["userid"]
        self.username <- map["username"]
        self.imgURL <- map["imgURL"]
        self.dest <- map["dest"]
        self.transactionDesc <- map["TransactionDesc"]
        self.baseUrl <- map["BaseUrl"]
        self.locationPath <- map["LocationPath"]
        self.noqs <- map["Noqs"]
        self.destinationUserID <- map["DestinationUserID"]
        self.destinationUserName <- map["DestinationUserName"]
        self.destinationImageUrl <- map["DestinationImageUrl"]
        self.referenceNo <- map["ReferenceNo"]
        self.destinationEmail <- map["DestinationEmail"]
        self.mobileNumber <- map["MobileNumber"]
        self.userType <- map["UserType"]
        self.QPAN <- map["QPAN"]
        self.referenceNo <- map["ReferenceNo"]
        self.refundStatus <- map["RefundStatus"]
        self.isAlreadyBeneficiary <- map["IsAlreadyBeneficiary"]
    }
}
