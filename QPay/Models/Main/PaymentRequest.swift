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

struct PaymentRequest : Mappable {
    
    var iD : Int?
    var requestDate : String?
    var requestByUserID : Int?
    var requestByUserName : String?
    var statusID : Int?
    var status : String?
    var requestToUserID : Int?
    var requestToUserName : String?
    var accessToken : String?
    var verificationID : String?
    var counter : Int?
    var completedDate : String?
    var requestID : String?
    var currencyID : Int?
    var platForm : String?
    var amount : Double?
    var entryTime : String?
    var modifiedTime : String?
    var modifiedBy : Int?
    var imageURL : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        iD <- map["ID"]
        requestDate <- map["RequestDate"]
        requestByUserID <- map["RequestByUserID"]
        requestByUserName <- map["RequestByUserName"]
        statusID <- map["StatusID"]
        status <- map["Status"]
        requestToUserID <- map["RequestToUserID"]
        requestToUserName <- map["RequestToUserName"]
        accessToken <- map["AccessToken"]
        verificationID <- map["VerificationID"]
        counter <- map["Counter"]
        completedDate <- map["CompletedDate"]
        requestID <- map["RequestID"]
        currencyID <- map["CurrencyID"]
        platForm <- map["PlatForm"]
        amount <- map["Amount"]
        entryTime <- map["EntryTime"]
        modifiedTime <- map["ModifiedTime"]
        modifiedBy <- map["ModifiedBy"]
        imageURL <- map["ImageURL"]
    }

}
