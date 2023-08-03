import Foundation
import ObjectMapper

struct PreviousJob : Mappable ,Codable {
    
	var id              : Int?
	var jobtitle        : String?
	var companyName     : String?
	var experience      : String?
	var country         : String?
	var city            : String?
	var jobStartdate    : String?
	var previousEnddate : String?
	var isJobDefault    : Bool?
    
    
    var _id : Int {
        get {
            return self.id ?? 0
        }
    }
    
    var _jobtitle : String {
        get {
            return self.jobtitle ?? ""
        }
    }
    
    var _companyNamee : String {
        get {
            return self.companyName ?? ""
        }
    }
    
    var _experience : String {
        get {
            return self.experience ?? ""
        }
    }
    
    var _country : String {
        get {
            return self.country ?? ""
        }
    }
    
    var _city : String {
        get {
            return self.city ?? ""
        }
    }
    
    var _jobStartdate : String {
        get {
            return self.jobStartdate ?? ""
        }
    }
    
    var _previousEnddate : String {
        get {
            return self.previousEnddate ?? ""
        }
    }
    
    var _isJobDefault : Bool {
        get {
            return self.isJobDefault ?? false
        }
    }

	init?(map: Map) {

	}
    init() {
    
    }

	mutating func mapping(map: Map) {

		id              <- map["ID"]
		jobtitle        <- map["Jobtitle"]
		companyName     <- map["CompanyName"]
		experience      <- map["Experience"]
		country         <- map["Country"]
		city            <- map["City"]
		jobStartdate    <- map["JobStartdate"]
		previousEnddate <- map["PreviousEnddate"]
		isJobDefault    <- map["IsJobDefault"]
	}

}
