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

struct GiftBrand: Mappable {
    
    var id: Int?
    private var brandID: Int?
    var name: String?
    var imageLocationPath: String?
    var thumbnailLocationPath: String?
    var storeID: String?
    var categoryID: String?
    var categoryName: String?
    var url: String?
    var icon: String?
    
    var _id: Int {
        get {
            return self.id ?? -1
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _imageLocationPath: String {
        get {
            return self.imageLocationPath ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["ID"]
        brandID <- map["BrandID"]
        name <- map["BrandName"]
        imageLocationPath <- map["BrandImageLocationPath"]
        thumbnailLocationPath <- map["BrandThumbnailLocationPath"]
        storeID <- map["storeId"]
        categoryID <- map["CategoryId"]
        categoryName <- map["CategoryName"]
        url <- map["URL"]
        icon <- map["icon"]
    }
}











