//
//  Store.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

struct GiftDenomination: Mappable {
    
    var id: Int?
    var brandID: Int?
    var brandName: String?
    var denomination: String?
    var imageLocationPath: String?
    var thumbnailLocationPath: String?
    var price: Double?
    var mobilePrice: Double?
    var description: String?
    var isDefault: Bool?
    var brandDescription: String?
    var denominationLink: String?
    var showInIOS: Bool?
    var showInAndroid: Bool?
    var smsKeyWord: String?
    var store: String?
    var storeID: String?
    var categoryName: String?
    var storeIcon: String?
    var storeURl: String?
    var supplierID: Int?
    var priceUSD: Double?
    var mobilePriceUSD: Double?
    
    var _id: Int {
        get {
            return self.id ?? -1
        }
    }
    
    var _brandName: String {
        get {
            return self.brandName ?? ""
        }
    }
    
    var _store: String {
        get {
            return self.store ?? ""
        }
    }
    
    var _denomination: String {
        get {
            return self.denomination ?? ""
        }
    }
    
    var _categoryName: String {
        get {
            return self.categoryName ?? ""
        }
    }
    
    var _description: String {
        get {
            return self.description ?? ""
        }
    }
    
    var _imageLocationPath: String {
        get {
            return self.imageLocationPath ?? ""
        }
    }
    
    var _storeIcon: String {
        get {
            return self.storeIcon ?? ""
        }
    }
    
    var _storeURl: String {
        get {
            return self.storeURl ?? ""
        }
    }
    
    var _price: Double {
        get {
            return self.price ?? 0.0
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["ID"]
        brandID <- map["BrandID"]
        brandName <- map["BrandName"]
        denomination <- map["Denomination"]
        imageLocationPath <- map["ImageLocationPath"]
        thumbnailLocationPath <- map["ThumbnailLocationPath"]
        price <- map["Price"]
        mobilePrice <- map["MobilePrice"]
        description <- map["Description"]
        isDefault <- map["IsDefault"]
        brandDescription <- map["BrandDescription"]
        denominationLink <- map["DenominationLink"]
        showInIOS <- map["ShowInIOS"]
        showInAndroid <- map["ShowInAndroid"]
        smsKeyWord <- map["SmsKeyWord"]
        store <- map["Store"]
        storeID <- map["StoreID"]
        categoryName <- map["CategoryName"]
        storeIcon <- map["Icon"]
        storeURl <- map["StoreURl"]
        supplierID <- map["SupplierID"]
        priceUSD <- map["PriceUSD"]
        mobilePriceUSD <- map["MobilePriceUSD"]
    }
}
