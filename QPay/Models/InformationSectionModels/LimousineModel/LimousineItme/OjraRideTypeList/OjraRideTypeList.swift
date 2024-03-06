

import Foundation
import ObjectMapper

struct OjraRideTypeList : Mappable  , Codable {
	var carTypeDetails          : [CarTypeDetails]?
	var buisnessCategoryDetails : [BuisnessCategoryDetails]?

    var _carTypeDetails : [CarTypeDetails] {
        get {
            return carTypeDetails ?? []
        }
    }
    
    var _buisnessCategoryDetails : [BuisnessCategoryDetails] {
        get {
            return buisnessCategoryDetails ?? []
        }
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		carTypeDetails <- map["CarTypeDetails"]
		buisnessCategoryDetails <- map["BuisnessCategoryDetails"]
	}

}
