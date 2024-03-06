
import Foundation
import ObjectMapper

struct OjraAccountInfoList : Mappable , Codable {
	var companyName   : String?
	var managerName   : String?
	var managerEmail  : String?
	var managerMobile : String?

    var _companyName   : String{
        get {
            return  companyName ?? ""
        }
    }
    var _managerName   : String{
        get {
            return managerName ?? ""
        }
    }
    var _managerEmail  : String{
        get {
            return managerEmail ?? ""
        }
    }
    var _managerMobile : String{
        get {
            return managerMobile ?? ""
        }
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		companyName <- map["CompanyName"]
		managerName <- map["ManagerName"]
		managerEmail <- map["ManagerEmail"]
		managerMobile <- map["ManagerMobile"]
	}

}
