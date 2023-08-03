//
//  InsurancesItmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 10/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct InsurancesItmeDetails : Mappable  {
    
    var email                        : String?
    var ID                           : Int?
    var insuranceAccountInfoList     : [AccountInfo]?
    var insuranceWorkingSetUpList    : [WorkingSetUp]?
    var insuranceServiceTypeList     : [ServiceType]?
    var insuranceUploadImagesList    : [UploadImages]?
    var insuranceCatelogueImagesList : [CatelogueImages]?
    
    var _email : String{
        get {
            return email ?? ""
        }
    }
    
    var _ID : Int{
        get {
            return ID ?? 0
        }
    }
    
    var _insuranceAccountInfoList : [AccountInfo]{
        get {
            return insuranceAccountInfoList ?? []
        }
    }
    
    var _insuranceWorkingSetUpList : [WorkingSetUp]{
        get {
            return insuranceWorkingSetUpList ?? []
        }
    }
    
    var _insuranceServiceTypeList : [ServiceType]{
        get {
            return insuranceServiceTypeList ?? []
        }
    }
    
    var _insuranceUploadImagesList : [UploadImages]{
        get {
            return insuranceUploadImagesList ?? []
        }
    }
    
    var _insuranceCatelogueImagesList : [CatelogueImages]{
        get {
            return insuranceCatelogueImagesList ?? []
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        email                        <- map["Insurance_Email"]
        ID                           <- map["Insurance_ID"]
        insuranceAccountInfoList     <- map["InsuranceAccountInfoList"]
        insuranceWorkingSetUpList    <- map["InsuranceWorkingSetUpList"]
        insuranceServiceTypeList     <- map["InsuranceServiceTypeList"]
        insuranceUploadImagesList    <- map["InsuranceUploadImagesList"]
        insuranceCatelogueImagesList <- map["InsuranceCatelogueImagesList"]
    }
    
}
