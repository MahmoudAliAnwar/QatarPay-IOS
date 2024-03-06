//
//  
//  InvoiceApp.swift
//  QPay
//
//  Created by Mohammed Hamad on 28/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct InvoiceApp : Mappable {
    
    var date: String?
    var number: String?
    var description: String?
    var discount: Double?
    var amount: Double?
    var note: String?
    var recipitantName: String?
    var recipitantCompany: String?
    var recipitantAddress: String?
    var recipitantEmail: String?
    var recipitantMobile: String?
    var id: Int?
    var status: String?
    var username: String?
    var userID: Int?
    var email: String?
    var mobile: String?
    var company: String?
    var address: String?
    var logo: String?
    var sessionID: String?
    var uuid: String?
    var isAcive: Bool?
    
    enum Status: String, CaseIterable {
        case success = "Success"
        case pending = "Pending"
        case failed = "Failed"
        case void = "Void"
        
        /*
         paid == Success
         outstanding == pending
         overdue == pending and due date is > current date
         all == all
         */
        
        var color: UIColor {
            get {
                switch self {
                case .success: return .systemGreen
                case .pending: return .systemYellow
                case .failed: return .systemRed
                case .void: return .systemGray
                }
            }
        }
    }
    
    var _date: String {
        get {
            return date ?? ""
        }
    }
    
    var _number: String {
        get {
            return number ?? ""
        }
    }
    
    var _description: String {
        get {
            return description ?? ""
        }
    }
    
    var _discount: Double {
        get {
            return discount ?? 0.0
        }
    }
    
    var _amount: Double {
        get {
            return amount ?? 0.0
        }
    }
    
    var _note: String {
        get {
            return note ?? ""
        }
    }
    
    var _recipitantName: String {
        get {
            return recipitantName ?? ""
        }
    }
    
    var _recipitantCompany: String {
        get {
            return recipitantCompany ?? ""
        }
    }
    
    var _recipitantAddress: String {
        get {
            return recipitantAddress ?? ""
        }
    }
    
    var _recipitantEmail: String {
        get {
            return recipitantEmail ?? ""
        }
    }
    
    var _recipitantMobile: String {
        get {
            return recipitantMobile ?? ""
        }
    }
    
    var _id: Int {
        get {
            return id ?? 0
        }
    }
    
    var _status: String {
        get {
            return status ?? ""
        }
    }
    
    var _statusObject: Status? {
        get {
            return Status(rawValue: self._status)
        }
    }
    
    var _username: String {
        get {
            return username ?? ""
        }
    }
    
    var _userID: Int {
        get {
            return userID ?? 0
        }
    }
    
    var _email: String {
        get {
            return email ?? ""
        }
    }
    
    var _mobile: String {
        get {
            return mobile ?? ""
        }
    }
    
    var _company: String {
        get {
            return company ?? ""
        }
    }
    
    var _address: String {
        get {
            return address ?? ""
        }
    }
    
    var _logo: String {
        get {
            return logo ?? ""
        }
    }
    
    var _sessionID: String {
        get {
            return sessionID ?? ""
        }
    }
    
    var _uuid: String {
        get {
            return uuid ?? ""
        }
    }
    
    var _IsAcive: Bool {
        get {
            return isAcive ?? false
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.date <- map["InvoiceDate"]
        self.number <- map["InvoiceNo"]
        self.description <- map["InvoiceDescription"]
        self.discount <- map["Discount"]
        self.amount <- map["InvoiceAmount"]
        self.note <- map["InvoiceNote"]
        self.recipitantName <- map["RecipitantName"]
        self.recipitantCompany <- map["RecipitantCompany"]
        self.recipitantAddress <- map["RecipitantAddress"]
        self.recipitantEmail <- map["RecipitantEmail"]
        self.recipitantMobile <- map["RecipitantMobile"]
        self.id <- map["InvoiceID"]
        self.status <- map["Status"]
        self.username <- map["UserName"]
        self.userID <- map["UserID"]
        self.email <- map["Email"]
        self.mobile <- map["Mobile"]
        self.company <- map["Company"]
        self.address <- map["Address"]
        self.logo <- map["LogoLocation"]
        self.sessionID <- map["SessionID"]
        self.uuid <- map["UUID"]
        self.isAcive <- map["IsAcive"]
    }
}
