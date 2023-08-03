
import Foundation
import ObjectMapper

struct Education : Mappable , Codable {
    
	var id                  : Int?
	var educationUniversity : String?
	var educationDegree     : String?
	var educationYear       : String?
	var educationCountry    : String?
	var educationCity       : String?
	var educationStartDate  : String?
	var educationEndDate    : String?
	var isDefault           : Bool?
    
    var _id : Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _educationUniversity : String {
        get {
            return self.educationUniversity ?? ""
        }
    }
    
    var _degree : String {
        get {
            return self.educationDegree ?? ""
        }
    }
    
    var _year : String {
        get {
            return self.educationYear ?? ""
        }
    }
    
    var _country : String {
        get {
            return self.educationCountry ?? ""
        }
    }
    
    var _city : String {
        get {
            return self.educationCity ?? ""
        }
    }
    
    var _startdate : String {
        get {
            return self.educationStartDate ?? ""
        }
    }
    
    var _enddate : String {
        get {
            return self.educationEndDate ?? ""
        }
    }
    
    var _isDefault : Bool {
        get {
            return self.isDefault ?? false
        }
    }
    
	init?(map: Map) {

	}
    
    init() {
        
    }

	mutating func mapping(map: Map) {

		id                  <- map["ID"]
		educationUniversity <- map["EducationUniversity"]
		educationDegree     <- map["EducationDegree"]
		educationYear       <- map["EducationYear"]
		educationCountry    <- map["EducationCountry"]
		educationCity       <- map["EducationCity"]
		educationStartDate  <- map["Educationstartdate"]
		educationEndDate    <- map["EducationEnddate"]
		isDefault           <- map["IsDefault"]
	}
}
