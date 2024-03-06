//
//  DineItmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct DineItmeDetails : Mappable {
    
    var email                   : String?
    var ID                      : Int?
    var dineAccountInfoList     : [AccountInfo]?
    var dineWorkingSetUpList    : [WorkingSetUp]?
    var dineServiceTypeList     : [ServiceType]?
    var dineUploadImagesList    : [UploadImages]?
    var dineCatelogueImagesList : [CatelogueImages]?
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _ID : Int {
        get {
            return ID ?? 0
        }
    }
    
    var _dineAccountInfoList : [AccountInfo] {
        get {
            return dineAccountInfoList ?? []
        }
    }
    
    var _dineWorkingSetUpList : [WorkingSetUp] {
        get {
            return dineWorkingSetUpList ?? []
        }
    }
    
    var _dineServiceTypeList : [ServiceType] {
        get {
            return dineServiceTypeList ?? []
        }
    }
    
    var _dineUploadImagesList : [UploadImages] {
        get {
            return dineUploadImagesList ?? []
        }
    }
    
    var _dineCatelogueImagesList : [CatelogueImages] {
        get {
            return dineCatelogueImagesList ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        email                   <- map["Dine_Email"]
        ID                      <- map["Dine_ID"]
        dineAccountInfoList     <- map["DineAccountInfoList"]
        dineWorkingSetUpList    <- map["DineWorkingSetUpList"]
        dineServiceTypeList     <- map["DineServiceTypeList"]
        dineUploadImagesList    <- map["DineUploadImagesList"]
        dineCatelogueImagesList <- map["DineCatelogueImagesList"]
    }
    
}
