//
//  BaseResponse.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/24/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseResponse: Mappable, Decodable {
    
    var success : Bool?
    var code    : String?
    var message : String?
    var errors  : [String]?
    
    /// Request
    var requestID: Int?
    
    /// Create Shop Order Response
    var orderPaymentLink: String?
    /// Create Shop Order Response
    var orderID: Int?
    
    /// Upload Images Response
    var imageID: Int?
    /// Upload Images Response
    var imageLocation: String?
    var fileName : String?
    
    /// Document ID Upload Response
    var documentID: Int?
    /// Document Location Upload Response
    var documentLocation: String?
    
    /// Update Address Response
    var latitude: String?
    /// Update Address Response
    var longitude: String?
    
    /// Topup Settings Response
    var maxAmountPerDay: Double?
    /// Topup Settings Response
    var maxAmountPerMonth: Double?
    /// Topup Settings Response
    var defaultTopupAmount: Double?
    
    /// Reserve ID Topup Response
    var accessToken : String?
    /// Reserve ID Topup Response
    var verificationID : String?
    /// Reserve ID Topup Response
    var topupRequestID: String?
    /// Reserve ID Topup Response
    var amount : Double?
    
    /// Initiate Karwa Bus Response
    var referenceNumber: String?
    /// Initiate Karwa Bus Response
    var clientReference: String?
    /// Get Karwa Card Balance Response
    var cardBalance: String?
    /// Get Karwa Card Balance Response
    var pendingCardBalance: String?
    
    /// Get Refill Charge Response
    var serviceCharge : Double?
    var baseAmount    : Double?
    var totalAmount   : Double?
    var validationURL : String?
    var paymentLink   : String?
    
    /// ApplePay
    var platformSessionID: String?
    var sessionID: String?
    var uuid: String?
    var paymentRequestID:  Int?
    var referenceNo: String?
    var paymentToken: String?
    
    var _serviceCharge : Double {
        get {
            return self.serviceCharge ?? 0
        }
    }
    
    var _baseAmount : Double {
        get {
            return self.baseAmount ?? 0
        }
    }
    
    var _totalAmount : Double {
        get {
            return self.totalAmount ?? 0
        }
    }
    
    var _validationURL : String {
        get {
            return self.validationURL ?? ""
        }
    }
    
    var _paymentLink : String {
        get {
            return self.paymentLink ?? ""
        }
    }
    
    /// Subscription Response
    var isSubscribed: Bool?,
        subscriptionFee: Double?,
        dueDate: String?
    
    /// Subscription Response
    var _isSubscribed: Bool {
        get {
            self.isSubscribed ?? false
        }
    }
    
    /// Subscription Response
    var _subscriptionFee: Double {
        get {
            self.subscriptionFee ?? 0.0
        }
    }
    
    /// Subscription Response
    var _dueDate: String {
        get {
            self.dueDate ?? ""
        }
    }
    
    var _success: Bool {
        get {
            return self.success ?? false
        }
    }
    
    var _code: String {
        get {
            return self.code ?? ""
        }
    }
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.requestID <- map["RequestID"]
        self.orderPaymentLink <- map["OrderPaymentLink"]
        self.orderID <- map["OrderID"]
        self.imageID <- map["ImageID"]
        self.imageLocation <- map["ImageLocation"]
        self.fileName <- map["FileName"]
        
        self.documentID <- map["DocumentID"]
        self.documentLocation <- map["DocumentLocation"]
        
        self.latitude <- map["Latitude"]
        self.longitude <- map["Longitude"]
        
        self.maxAmountPerDay <- map["MaxAmountPerDay"]
        self.maxAmountPerMonth <- map["MaxAmountPerMonth"]
        self.defaultTopupAmount <- map["DefaultTopupAmount"]
        
        self.accessToken <- map["AccessToken"]
        self.verificationID <- map["VerificationID"]
        
        self.topupRequestID <- map["RequestID"]
        self.amount <- map["Amount"]
        
        self.referenceNumber <- map["ReferenceNumber"]
        self.clientReference <- map["ClientReference"]
        
        self.cardBalance <- map["CardBalance"]
        self.pendingCardBalance <- map["PendingCardBalance"]
        
        self.serviceCharge      <- map["service_charge"]
        self.baseAmount         <- map["BaseAmount"]
        self.totalAmount        <- map["TotalAmount"]
        self.validationURL      <- map["ValidationURL"]
        self.paymentLink        <- map["PaymentLink"]
        
        
        self.platformSessionID  <- map["PlatformSessionID"]
        self.sessionID          <- map["SessionID"]
        self.uuid               <- map["UUID"]
        self.paymentRequestID   <- map["PaymentRequestID"]
        self.referenceNo        <- map["ReferenceNo"]
        
        
        self.isSubscribed       <- map["IsSubscribed"]
        self.subscriptionFee    <- map["SubscriptionFee"]
        self.dueDate            <- map["DueDate"]
        
        self.success            <- map["success"]
        self.code               <- map["code"]
        self.message            <- map["message"]
        self.errors             <- map["errors"]
    }
}
