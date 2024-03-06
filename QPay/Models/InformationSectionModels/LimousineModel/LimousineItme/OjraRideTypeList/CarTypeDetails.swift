

import Foundation
import ObjectMapper

struct CarTypeDetails : Mappable , Codable {
    var car              : String?
    var carImageLocation : String?
    var carTypeID        : Int?
    
    var _car : String {
        get {
            return car ?? ""
        }
    }
    
    var _carImageLocation : String {
        get {
            return carImageLocation ?? ""
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        car <- map["Car"]
        carImageLocation <- map["CarImageLocation"]
        carTypeID <- map["CarTypeID"]
    }
    
}
