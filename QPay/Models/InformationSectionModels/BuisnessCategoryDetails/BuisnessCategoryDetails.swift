

import Foundation
import ObjectMapper

struct BuisnessCategoryDetails : Mappable , Codable {
	var buisness           : String?
	var buisnessCategoryID : Int?

    var _buisness : String {
        get {
            return buisness ?? ""
        }
    }
    
    var _buisnessCategoryID : Int {
        get {
            return buisnessCategoryID ?? 0
        }
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		buisness           <- map["Buisness"]
		buisnessCategoryID <- map["BuisnessCategoryID"]
	}

}
