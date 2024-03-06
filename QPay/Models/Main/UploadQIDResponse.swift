//
//  
//  UploadQIDResponse.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/11/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct UploadQIDResponse : Mappable {
    
    var imageLocation: String?
    var thumbnailLocation: String?
    var number: String?
    var expiryDate: String?
    var dob: String?
    var reminderTypeID: Int?
    var front: String?
    var back: String?
    var countryList: [Country]?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _imageLocation: String {
        get {
            return self.imageLocation ?? ""
        }
    }
    
    var _thumbnailLocation: String {
        get {
            return self.thumbnailLocation ?? ""
        }
    }
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _expiryDate: String {
        get {
            return expiryDate ?? ""
        }
    }
    
    var _dob: String {
        get {
            return dob ?? ""
        }
    }
    
    var _reminderTypeID: Int {
        get {
            return reminderTypeID ?? 0
        }
    }
    
    var _front: String {
        get {
            return front ?? ""
        }
    }
    
    var _back: String {
        get {
            return back ?? ""
        }
    }
    
    var _countryList: [Country] {
        get {
            return countryList ?? []
        }
    }
    
    var _success: Bool {
        get {
            return self.success ?? false
        }
    }
    
    var _message: String {
        get {
            return self.message ?? ""
        }
    }
    
    var _code: String {
        get {
            return self.code ?? ""
        }
    }
    
    var _errors: [String] {
        get {
            return self.errors ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.imageLocation <- map["ProfileImageLocation"]
        self.thumbnailLocation <- map["ThumbnailLocation"]
        self.number <- map["IDCardNumber"]
        self.expiryDate <- map["ExpiryDate"]
        self.dob <- map["DateofBirth"]
        self.reminderTypeID <- map["ReminderTypeID"]
        self.front <- map["front"]
        self.back <- map["back"]
        self.countryList <- map["CountryCodeList"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
    }
}
