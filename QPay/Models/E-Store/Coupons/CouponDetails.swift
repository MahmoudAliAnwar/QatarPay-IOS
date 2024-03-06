//
//  
//  CouponDetail.swift
//  QPay
//
//  Created by Mohammed Hamad on 22/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct CouponDetails : Codable, Mappable {
    
    var couponType: String?
    var couponValue: Double?
    var shortDescription: String?
    var longDescription: String?
    var couponImageLocation: String?
    var merchantImageLocation: String?
    var couponExpiryDate: String?
    var couponCode: String?
    var couponNumber: String?
    var merchantName: String?
    
    var _couponType: String {
        get {
            return couponType ?? ""
        }
    }
    
    var _couponValue: Double {
        get {
            return couponValue ?? 0.0
        }
    }
    
    var _shortDescription: String {
        get {
            return shortDescription ?? ""
        }
    }
    
    var _longDescription: String {
        get {
            return longDescription ?? ""
        }
    }
    
    var _couponImageLocation: String {
        get {
            return couponImageLocation ?? ""
        }
    }
    
    var _merchantImageLocation: String {
        get {
            return merchantImageLocation ?? ""
        }
    }
    
    var _couponExpiryDate: String {
        get {
            return couponExpiryDate ?? ""
        }
    }
    
    var _couponCode: String {
        get {
            return couponCode ?? ""
        }
    }
    
    var _couponNumber: String {
        get {
            return couponNumber ?? ""
        }
    }
    
    var _merchantName: String {
        get {
            return self.merchantName ?? ""
        }
    }
    
    var discountType: Coupon.DiscountType? {
        get {
            return Coupon.DiscountType(rawValue: _couponType)
        }
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.couponType <- map["CouponType"]
        self.couponValue <- map["CouponValue"]
        self.shortDescription <- map["ShortDescription"]
        self.longDescription <- map["LongDescription"]
        self.couponImageLocation <- map["CouponImageLocation"]
        self.merchantImageLocation <- map["MerchantImageLocation"]
        self.couponExpiryDate <- map["CouponExpiryDate"]
        self.couponCode <- map["CouponCode"]
        self.couponNumber <- map["CouponNumber"]
        self.merchantName <- map["MerchantName"]
    }
}
