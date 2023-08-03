//
//  MedicalCenterItmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct MedicalCenterItmeDetails : Mappable {
    
    var email                      : String?
    var ID                         : Int?
    var clinicsAccountInfoList     : [AccountInfo]?
    var clinicsWorkingSetUpList    : [WorkingSetUp]?
    var clinicsServiceTypeList     : [ServiceType]?
    var clinicsUploadImagesList    : [UploadImages]?
    var clinicsCatelogueImagesList : [CatelogueImages]?
    
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
    
    var _clinicsAccountInfoList : [AccountInfo] {
        get {
            return clinicsAccountInfoList ?? []
        }
    }
    
    var _clinicsWorkingSetUpList : [WorkingSetUp] {
        get {
            return clinicsWorkingSetUpList ?? []
        }
    }
    
    var _clinicsServiceTypeList : [ServiceType] {
        get {
            return clinicsServiceTypeList ?? []
        }
    }
    
    var _clinicsUploadImagesList : [UploadImages] {
        get {
            return clinicsUploadImagesList ?? []
        }
    }
    
    var _clinicsCatelogueImagesList : [CatelogueImages] {
        get {
            return clinicsCatelogueImagesList ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        email                      <- map["Clinics_Email"]
        ID                         <- map["Clinics_ID"]
        clinicsAccountInfoList     <- map["ClinicsAccountInfoList"]
        clinicsWorkingSetUpList    <- map["ClinicsWorkingSetUpList"]
        clinicsServiceTypeList     <- map["ClinicsServiceTypeList"]
        clinicsUploadImagesList    <- map["ClinicsUploadImagesList"]
        clinicsCatelogueImagesList <- map["ClinicsCatelogueImagesList"]
    }
    
}
