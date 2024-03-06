

import Foundation
import ObjectMapper

struct WorkingDays : Mappable , Codable {
    
	var workingDays : String?

    var _workingDays : String {
        get {
            return workingDays ?? ""
        }
    }

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		workingDays <- map["Working_Days"]
	}
}
