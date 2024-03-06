//
//  CurrentJob.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct CurrentJob: Mappable,Codable {
    
    var id           : Int?
    var jobTitle     : String?
    var companyName  : String?
    var experience   : String?
    var country      : String?
    var city         : String?
    var jobStartDate : String?
    var isJobDefault : Bool?
    
    var _id : Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _jobTitle : String {
        get {
            return self.jobTitle ?? ""
        }
    }

    var _companyNamee : String {
        get {
            return self.companyName ?? ""
        }
    }
    
    var _experience : String {
        get {
            return self.experience ?? ""
        }
    }
    
    var _country : String {
        get {
            return self.country ?? ""
        }
    }
    
    var _city : String {
        get {
            return self.city ?? ""
        }
    }
    
    var _jobStartDate : String {
        get {
            return self.jobStartDate ?? ""
        }
    }
    
    var _isJobDefault : Bool {
        get {
            return self.isJobDefault ?? false
        }
    }
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: ObjectMapper.Map) {
        
        id           <- map["ID"]
        jobTitle     <- map["Jobtitle"]
        companyName  <- map["CompanyName"]
        experience   <- map["Experience"]
        country      <- map["Country"]
        city         <- map["City"]
        jobStartDate <- map["JobStartdate"]
        isJobDefault <- map["IsJobDefault"]
    } 
}
