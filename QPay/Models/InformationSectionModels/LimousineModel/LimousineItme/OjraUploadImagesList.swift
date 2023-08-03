

import Foundation
import ObjectMapper

struct OjraUploadImagesList : Mappable , Codable {
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
