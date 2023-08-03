//
//  EmployerList.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/06/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

struct EmployerList : Mappable , Codable {
    
    var employer_name      : String?
    var employment_type    : String?
    var job_title          : String?
    var empLanguages       : String?
    var yearofexperience   : String?
    var industry           : String?
    var applicant_location : String?
    var desired_Skills     : String?
    var job_description    : String?
    var website            : String?
    var email              : String?
    var phone_number       : String?
    var current_location   : String?
    var noredoo_PhoneNo    : String?
    var iD_emp             : String?
    var expairedDate       : String?
    var iP_device          : String?
    var region             : String?
    var add_Cat            : String?
    var member_Type        : String?
    var sim_location       : String?
    var post_location      : String?
    var allowNoredochat    : String?
    var account_ID         : String?
    var gender             : String?
    var logo               : String?
    var postDate           : String?
    var employer_id        : Double?
    
    
    var _employer_name : String {
        get {
            return employer_name ?? ""
        }
    }
    
    var _employment_type : String {
        get {
            return employment_type ?? ""
        }
    }
    
    var _job_title : String {
        get {
            return job_title ?? ""
        }
    }
    
    var _empLanguages : String {
        get {
            return empLanguages ?? ""
        }
    }
    
    var _yearofexperience : String {
        get {
            return yearofexperience ?? ""
        }
    }
    
    var _industry : String {
        get {
            return industry ?? ""
        }
    }
    
    var _applicant_location : String {
        get {
            return applicant_location ?? ""
        }
    }
    
    var _desired_Skills : String {
        get {
            return desired_Skills ?? ""
        }
    }
    
    var _job_description : String {
        get {
            return job_description ?? ""
        }
    }
    
    var _website : String {
        get {
            return website ?? ""
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _phone_number : String {
        get {
            return phone_number ?? ""
        }
    }
    
    var _current_location : String {
        get {
            return current_location ?? ""
        }
    }
    
    var _noredoo_PhoneNo : String {
        get {
            return noredoo_PhoneNo ?? ""
        }
    }
    
    var _iD_emp : String {
        get {
            return iD_emp ?? ""
        }
    }
    
    var _expairedDate : String {
        get {
            return expairedDate ?? ""
        }
    }
    
    var _iP_device : String {
        get {
            return iP_device ?? ""
        }
    }
    
    var _region : String {
        get {
            return region ?? ""
        }
    }
    
    var _add_Cat : String {
        get {
            return add_Cat ?? ""
        }
    }
    
    var _member_Type : String {
        get {
            return member_Type ?? ""
        }
    }
    
    var _sim_location : String {
        get {
            return sim_location ?? ""
        }
    }
    
    var _post_location : String {
        get {
            return post_location ?? ""
        }
    }
    
    var _allowNoredochat : String {
        get {
            return allowNoredochat ?? ""
        }
    }
    
    var _account_ID : String {
        get {
            return account_ID ?? ""
        }
    }
    
    var _gender : String {
        get {
            return gender ?? ""
        }
    }
    
    var _logo : String {
        get {
            return logo ?? ""
        }
    }
    
    var _postDate : String {
        get {
            return postDate ?? ""
        }
    }
    
    var _employer_id : Double{
        get {
            return employer_id ?? 0
        }
    }
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
        employer_name <- map["Employer_name"]
        employment_type <- map["Employment_type"]
        job_title <- map["Job_title"]
        empLanguages <- map["empLanguages"]
        yearofexperience <- map["Yearofexperience"]
        industry <- map["Industry"]
        applicant_location <- map["Applicant_location"]
        desired_Skills <- map["Desired_Skills"]
        job_description <- map["Job_description"]
        website <- map["Website"]
        email <- map["Email"]
        phone_number <- map["Phone_number"]
        current_location <- map["Current_location"]
        noredoo_PhoneNo <- map["Noredoo_PhoneNo"]
        iD_emp <- map["ID_emp"]
        expairedDate <- map["ExpairedDate"]
        iP_device <- map["IP_device"]
        region <- map["Region"]
        add_Cat <- map["Add_Cat"]
        member_Type <- map["Member_Type"]
        sim_location <- map["Sim_location"]
        post_location <- map["post_location"]
        allowNoredochat <- map["AllowNoredochat"]
        account_ID <- map["Account_ID"]
        gender <- map["gender"]
        logo <- map["logo"]
        postDate <- map["PostDate"]
        employer_id <- map["Employer_id"]
    }
    
}
