//
//  
//  Coupon.swift
//  QPay
//
//  Created by Mohammed Hamad on 15/12/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//
//
import Foundation
import UIKit
import ObjectMapper

struct Coupon : Mappable {
    
    var couponID: Int?
    var couponCode: String?
    var couponDescription: String?
    var couponName: String?
    var couponImageLocation: String?
    var couponExpiryDate: String?
    var couponType: String?
    var couponValue: Double?
    var merchantName: String?
    var merchantImageLocation: String?
    var merchantMobile: String?
    var merhantEmail: String?
    var merchantPhoneNumber: String?
    var categoryID: Int?
    
    var _couponID: Int {
        get {
            return couponID ?? 0
        }
    }
    
    var _couponCode: String {
        get {
            return couponCode ?? ""
        }
    }
    
    var _couponDescription: String {
        get {
            return couponDescription ?? ""
        }
    }
    
    var _couponName: String {
        get {
            return couponName ?? ""
        }
    }
    
    var _couponImageLocation: String {
        get {
            return couponImageLocation ?? ""
        }
    }
    
    var _couponExpiryDate: String {
        get {
            return couponExpiryDate ?? ""
        }
    }
    
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
    
    var _merchantName: String {
        get {
            return merchantName ?? ""
        }
    }
    
    var _merchantImageLocation: String {
        get {
            return merchantImageLocation ?? ""
        }
    }
    
    var _merchantMobile: String {
        get {
            return merchantMobile ?? ""
        }
    }
    
    var _merhantEmail: String {
        get {
            return merhantEmail ?? ""
        }
    }
    
    var _merchantPhoneNumber: String {
        get {
            return merchantPhoneNumber ?? ""
        }
    }
    
    var _categoryID: Int {
        get {
            return self.categoryID ?? 0
        }
    }
    
    var discountType: DiscountType? {
        get {
            return DiscountType(rawValue: _couponType)
        }
    }
    
    enum DiscountType: String, CaseIterable {
        case Discount
        case Percent = "Discount Percent"
        case OneFree = "Buy one get one free"
    }
    
    init() {
        
    }
    
    init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.couponID <- map["CouponID"]
        self.couponCode <- map["CouponCode"]
        self.couponDescription <- map["CouponDescription"]
        self.couponName <- map["CouponName"]
        self.couponImageLocation <- map["CouponImageLocation"]
        self.couponExpiryDate <- map["CouponExpiryDate"]
        self.couponType <- map["CouponType"]
        self.couponValue <- map["CouponValue"]
        self.merchantName <- map["MerchantName"]
        self.merchantImageLocation <- map["MerchantImageLocation"]
        self.merchantMobile <- map["MerchantMobile"]
        self.merhantEmail <- map["MerhantEmail"]
        self.merchantPhoneNumber <- map["MerchantPhoneNumber"]
        self.categoryID <- map["CategoryId"]
    }
}
