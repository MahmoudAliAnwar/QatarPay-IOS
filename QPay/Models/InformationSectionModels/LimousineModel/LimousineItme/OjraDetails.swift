
import Foundation
import ObjectMapper

struct OjraDetails : Mappable , Codable {
    
	var ojra_Email              : String?
	var ojra_ID                 : Int?
	var ojraAccountInfoList     : [OjraAccountInfoList]?
	var ojraWorkingSetUpList    : [OjraWorkingSetUpList]?
	var ojraRideTypeList        : [OjraRideTypeList]?
	var ojraUploadImagesList    : [OjraUploadImagesList]?
	var ojraCatelogueImagesList : [OjraCatelogueImagesList]?
    
    var _ojra_Email : String{
        get {
            return ojra_Email ?? ""
        }
    }

    var _ojra_ID : Int {
        get {
            return ojra_ID ?? 0
        }
    }
    
    var _ojraAccountInfoList : [OjraAccountInfoList]{
        get {
            return ojraAccountInfoList ?? []
        }
    }
    
    var _ojraWorkingSetUpList : [OjraWorkingSetUpList]{
        get {
            return ojraWorkingSetUpList ?? []
        }
    }
    
    var _ojraRideTypeList : [OjraRideTypeList]{
        get {
            return ojraRideTypeList ?? []
        }
    }
    
    var _ojraUploadImagesList : [OjraUploadImagesList]{
        get {
            return ojraUploadImagesList ?? []
        }
    }
    
    var _ojraCatelogueImagesList : [OjraCatelogueImagesList]{
        get {
            return ojraCatelogueImagesList ?? []
        }
    }

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		ojra_Email <- map["Ojra_Email"]
		ojra_ID <- map["Ojra_ID"]
		ojraAccountInfoList <- map["OjraAccountInfoList"]
		ojraWorkingSetUpList <- map["OjraWorkingSetUpList"]
		ojraRideTypeList <- map["OjraRideTypeList"]
		ojraUploadImagesList <- map["OjraUploadImagesList"]
		ojraCatelogueImagesList <- map["OjraCatelogueImagesList"]
	}

}
