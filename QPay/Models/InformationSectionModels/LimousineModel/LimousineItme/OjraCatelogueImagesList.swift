
import Foundation
import ObjectMapper

struct OjraCatelogueImagesList : Mappable , Codable {
	var catelogue : String?
    
    var _catelogue : String {
        get {
            return catelogue ?? ""
        }
    }

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		catelogue <- map["Catelogue"]
	}

}
