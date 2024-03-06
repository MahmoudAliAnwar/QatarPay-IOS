//
//  HoteltmeDetails.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct HotelItmeDetails : Mappable {
    
    var email                    : String?
    var ID                       : Int?
    var hotelAccountInfoList     : [AccountInfo]?
    var hotelWorkingSetUpList    : [WorkingSetUp]?
    var hotelServiceTypeList     : [HotelServiceTypeList]?
    var hotelUploadImagesList    : [UploadImages]?
    var hotelCatelogueImagesList : [CatelogueImages]?
    
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
    
    var _hotelAccountInfoList : [AccountInfo] {
        get {
            return hotelAccountInfoList ?? []
        }
    }
    
    var _hotelWorkingSetUpList : [WorkingSetUp] {
        get {
            return hotelWorkingSetUpList ?? []
        }
    }
    
    var _hotelServiceTypeList : [HotelServiceTypeList] {
        get {
            return hotelServiceTypeList ?? []
        }
    }
    
    var _hotelUploadImagesList : [UploadImages] {
        get {
            return hotelUploadImagesList ?? []
        }
    }
    
    var _hotelCatelogueImagesList : [CatelogueImages] {
        get {
            return hotelCatelogueImagesList ?? []
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        email                     <- map["Hotel_Email"]
        ID                        <- map["Hotel_ID"]
        hotelAccountInfoList      <- map["HotelAccountInfoList"]
        hotelWorkingSetUpList     <- map["HotelWorkingSetUpList"]
        hotelServiceTypeList      <- map["HotelServiceTypeList"]
        hotelUploadImagesList     <- map["HotelUploadImagesList"]
        hotelCatelogueImagesList  <- map["HotelCatelogueImagesList"]
    }
    
}
