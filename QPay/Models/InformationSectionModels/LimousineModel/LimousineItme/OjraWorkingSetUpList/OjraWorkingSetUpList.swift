
import Foundation
import ObjectMapper

struct OjraWorkingSetUpList : Mappable , Codable {
    var workingDays : [WorkingDays]?
    var workingFrom : String?
    var workingTo   : String?
    var address     : String?
    var email       : String?
    var web         : String?
    var locationGPS : String?
    var office      : String?
    var orderLine   : String?
    var rating      : Double?
    var isFeatured  : Bool?
    var contactType : String?
    var isItemAdded : Bool?
    
    var _workingDays : [WorkingDays] {
        get {
            return workingDays ?? []
        }
    }
    
    var _workingFrom : String {
        get {
            return workingFrom ?? ""
        }
    }
    
    var _workingTo : String {
        get {
            return workingTo ?? ""
        }
    }
    
    var _address : String {
        get {
            return address ?? ""
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _web : String {
        get {
            return web ?? ""
        }
    }
    
    var _locationGPS : String {
        get {
            return locationGPS ?? ""
        }
    }
    
    var _office : String {
        get {
            return office ?? ""
        }
    }
    
    var _orderLine : String {
        get {
            return orderLine ?? ""
        }
    }
    
    var _rating : Double {
        get {
            return rating ?? 0
        }
    }
    
    var _isFeatured  : Bool{
        get {
            return isFeatured ?? false
        }
    }
    
    var _contactType : String{
        get {
            return contactType ?? ""
        }
    }
    
    var _isItemAdded : Bool{
        get {
            return isItemAdded ?? false
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        workingDays  <- map["WorkingDays"]
        workingFrom  <- map["WorkingFrom"]
        workingTo    <- map["WorkingTo"]
        address      <- map["Address"]
        email        <- map["Email"]
        web          <- map["Web"]
        locationGPS  <- map["LocationGPS"]
        office       <- map["Office"]
        orderLine    <- map["OrderLine"]
        rating       <- map["Rating"]
        isFeatured   <- map["IsFeatured"]
        contactType  <- map["ContactType"]
        isItemAdded  <- map["IsItemAdded"]
    }
    
}
