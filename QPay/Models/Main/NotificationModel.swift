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

struct NotificationModel : Mappable {
    
    var id : Int?
    var message : String?
    var title : String?
    var statusID : Int?
    var status : String?
    var deliveredTime : String?
    var sendByUser : String?
    var type : String?
    var typeID : Int?
    var isReadByUser : Bool?
    var referenceID : Int?
    var referenceStatusID : Int?
    var sendByUserImageLocation : String?
    var userImageLocation : String?
    
    init() {
        
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["ID"]
        message <- map["Message"]
        title <- map["Title"]
        statusID <- map["StatusID"]
        status <- map["Status"]
        deliveredTime <- map["DeliveredTime"]
        sendByUser <- map["SendByUser"]
        type <- map["NotificationType"]
        typeID <- map["NotificationTypeID"]
        isReadByUser <- map["IsReadByUser"]
        referenceID <- map["ReferenceID"]
        referenceStatusID <- map["ReferenceStatusID"]
        sendByUserImageLocation <- map["SendByUserImageLocation"]
        userImageLocation <- map["UserImageLocation"]
    }
}
