//
//  UploadImages.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct UploadImages : Mappable , Codable {
    
    var imageAd       : String?
    var imageOffer    : String?
    var imagePrices   : String?
    var imageAdID     : Int?
    var imageOfferID  : Int?
    var imagePricesID : Int?
    
    var _imageAd : String {
        get {
            return imageAd ?? ""
        }
    }
    
    var _imageOffer : String {
        get {
            return imageOffer ?? ""
        }
    }
    
    var _imagePrices : String {
        get {
            return imagePrices ?? ""
        }
    }
    
    var _imageAdID : Int{
        get {
            return imageAdID ?? 0
        }
    }
    
    var _imageOfferID : Int{
        get {
            return imageOfferID ?? 0
        }
    }
    
    var _imagePricesID : Int{
        get {
            return imagePricesID ?? 0
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        imageAd       <- map["ImageAd"]
        imageOffer    <- map["ImageOffer"]
        imagePrices   <- map["ImagePrices"]
        imageAdID     <- map["ImageAdID"]
        imageOfferID  <- map["ImageOfferID"]
        imagePricesID <- map["ImagePricesID"]
    }
    
}
