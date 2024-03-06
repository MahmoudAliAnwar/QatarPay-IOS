//
//  ChildCareItmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChildCareItmeDetails : Mappable {
    
    var email               : String?
    var ID                  : Int?
    var accountInfoList     : [AccountInfo]?
    var workingSetUpList    : [WorkingSetUp]?
    var serviceTypeList     : [ServiceType]?
    var uploadImagesList    : [UploadImages]?
    var catelogueImagesList : [CatelogueImages]?
    
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
    
    var _accountInfoList : [AccountInfo] {
        get {
            return accountInfoList ?? []
        }
    }
    
    var _workingSetUpList : [WorkingSetUp] {
        get {
            return workingSetUpList ?? []
        }
    }
    
    var _serviceTypeList : [ServiceType] {
        get {
            return serviceTypeList ?? []
        }
    }
    
    var _uploadImagesList : [UploadImages] {
        get {
            return uploadImagesList ?? []
        }
    }
    
    var _catelogueImagesList : [CatelogueImages] {
        get {
            return catelogueImagesList ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
        email               <- map["Nursery_Email"]
        ID                  <- map["Nursery_ID"]
        accountInfoList     <- map["NurseryAccountInfoList"]
        workingSetUpList    <- map["NurseryWorkingSetUpList"]
        serviceTypeList     <- map["NurseryServiceTypeList"]
        uploadImagesList    <- map["NurseryUploadImagesList"]
        catelogueImagesList <- map["NurseryCatelogueImagesList"]
    }
}
