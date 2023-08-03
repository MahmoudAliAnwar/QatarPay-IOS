//
//  QaterSchoolItmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 12/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct QaterSchoolItmeDetails : Mappable {
    
    var email                     : String?
    var ID                        : Int?
    var schoolAccountInfoList     : [AccountInfo]?
    var schoolWorkingSetUpList    : [WorkingSetUp]?
    var schoolServiceTypeList     : [ServiceType]?
    var schoolUploadImagesList    : [UploadImages]?
    var schoolCatelogueImagesList : [CatelogueImages]?
    
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
    
    var _schoolAccountInfoList : [AccountInfo] {
        get {
            return schoolAccountInfoList ?? []
        }
    }
    
    var _schoolWorkingSetUpList : [WorkingSetUp] {
        get {
            return schoolWorkingSetUpList ?? []
        }
    }
    
    var _schoolServiceTypeList : [ServiceType] {
        get {
            return schoolServiceTypeList ?? []
        }
    }
    
    var _schoolUploadImagesList : [UploadImages] {
        get {
            return schoolUploadImagesList ?? []
        }
    }
    
    var _schoolCatelogueImagesList : [CatelogueImages] {
        get {
            return schoolCatelogueImagesList ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        email                     <- map["School_Email"]
        ID                        <- map["School_ID"]
        schoolAccountInfoList     <- map["SchoolAccountInfoList"]
        schoolWorkingSetUpList    <- map["SchoolWorkingSetUpList"]
        schoolServiceTypeList     <- map["SchoolServiceTypeList"]
        schoolUploadImagesList    <- map["SchoolUploadImagesList"]
        schoolCatelogueImagesList <- map["SchoolCatelogueImagesList"]
    }
    
}
