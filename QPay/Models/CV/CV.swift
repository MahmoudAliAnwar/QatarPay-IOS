

import Foundation
import ObjectMapper

struct CV : Mappable , Codable {
	var phoneNumber : String?
	var name : String?
	var key : String = Constant.KEY
	var profilePicture : String?
	var skills : String?
	var resident : String?
	var nationality : String?
	var languages : String?
    var languageId : Int = 1
	var gender : String?
	var email : String?
	var website : String?
	var im : String?
	var twitter : String?
	var facebook : String?
	var privacyStatus : String?
	var totalExperience : String?
	var currentJobList : [CurrentJob]?
	var previousJobList : [PreviousJob]?
	var educationList : [Education]?
	var cVFIEL : String?
	var industry_Area : String?
	var profession_Area : String?
	var graduate : String?
	var salaryExpect : String?
	var account_ID : String?
	var cVID : Int?
    
    ///Local
    var profilePicId: Int?
    
    var _phoneNumber : String {
        get {
            return phoneNumber ?? ""
        }
    }
    
    var _name : String {
        get {
            return name ?? ""
        }
    }
    
     
    
    var _profilePicture : String {
        get {
            return profilePicture ?? ""
        }
    }
    
    var _skills : String {
        get {
            return skills ?? ""
        }
    }
    
    var _profilePicId: Int {
        get {
            return self.profilePicId ?? 0
        }
    }
    
    var _resident : String {
        get {
            return resident ?? ""
        }
    }
    
    var _nationality : String {
        get {
            return nationality ?? ""
        }
    }
    
    var _languages : String {
        get {
            return languages ?? ""
        }
    }
    
    var _gender : String {
        get {
            return gender ?? ""
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _website : String {
        get {
            return website ?? ""
        }
    }
    
    var _im : String {
        get {
            return im ?? ""
        }
    }
    
    var _twitter : String {
        get {
            return twitter ?? ""
        }
    }
    
    var _facebook : String {
        get {
            return facebook ?? ""
        }
    }
    
    var _privacyStatus : String {
        get {
            return privacyStatus ?? ""
        }
    }
    
    var _totalExperience : String {
        get {
            return totalExperience ?? ""
        }
    }
    
    var _currentJobList : [CurrentJob] {
        get {
            return currentJobList ?? []
        }
    }
    
    var _previousJobList : [PreviousJob] {
        get {
            return previousJobList ?? []
        }
    }
    
    var _educationList : [Education] {
        get {
            return educationList ?? []
        }
    }
    
    var _cVFIEL : String {
        get {
            return cVFIEL ?? ""
        }
    }
    
    var _industry_Area : String {
        get {
            return industry_Area ?? ""
        }
    }
    
    var _profession_Area : String {
        get {
            return profession_Area ?? ""
        }
    }
    
    var _graduate : String {
        get {
            return graduate ?? ""
        }
    }
    
    var _salaryExpect : String {
        get {
            return salaryExpect ?? ""
        }
    }
    
    var _account_ID : String {
        get {
            return account_ID ?? ""
        }
    }
    
    var _cVID : Int {
        get {
            return cVID ?? 0
        }
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        self.phoneNumber <- map["PhoneNumber"]
        self.name <- map["Name"]
        self.key <- map["key"]
        self.profilePicture <- map["ProfilePicture"]
        self.skills <- map["Skills"]
        self.resident <- map["Resident"]
        self.nationality <- map["Nationality"]
        self.languages <- map["Languages"]
        self.gender <- map["Gender"]
        self.email <- map["Email"]
        self.website <- map["Website"]
        self.im <- map["Im"]
        self.twitter <- map["Twitter"]
        self.facebook <- map["Facebook"]
        self.privacyStatus <- map["PrivacyStatus"]
        self.totalExperience <- map["TotalExperience"]
        self.currentJobList <- map["CurrentJobList"]
        self.previousJobList <- map["PreviousJobList"]
        self.educationList <- map["EducationList"]
        self.cVFIEL <- map["CVFIEL"]
        self.industry_Area <- map["Industry_Area"]
        self.profession_Area <- map["Profession_Area"]
        self.graduate <- map["Graduate"]
        self.salaryExpect <- map["SalaryExpect"]
        self.account_ID <- map["Account_ID"]
        self.cVID <- map["CVID"]
        self.profilePicId <- map["ProfilePicID"]
        self.languageId <- map["LanguageId"]
	}
}
