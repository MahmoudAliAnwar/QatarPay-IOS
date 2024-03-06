//
//  JobHuntList.swift
//  QPay
//
//  Created by Mohammed Hamad on 30/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import ObjectMapper

struct JobHunterList : Mappable , Codable {
    
    var employName : String?
    var employType : String?
    var jobTitle : String?
    var language : String?
    var yearOfExperience : String?
    var industry : String?
    var resident : String?
    var nationality : String?
    var skills : String?
    var email : String?
    var phoneNumber : String?
    var CV_URL : String?
    var employerName : String?
    var profilePictureURL : String?
    var currentLocation : String?
    var noredooPhoneNo : String?
    var iD_emp : String?
    var expairedDate : String?
    var iPDevice : String?
    var region : String?
    var addCat : String?
    var memberType : String?
    var simLocation : String?
    var postLocation : String?
    var allowNoredochat : String?
    var accountID : String?
    var gender : String?
    var postDate : String?
    var jobSeekerID : Double?
    
    var _employName : String {
        get {
            return employName ?? ""
        }
    }
    
    var _employType : String {
        get {
            return employType ?? ""
        }
    }
    
    var _jobTitle : String {
        get {
            return jobTitle ?? ""
        }
    }
    
    var _language : String {
        get {
            return language ?? ""
        }
    }
    
    var _yearOfExperience : String {
        get {
            return yearOfExperience ?? ""
        }
    }
    
    var _industry : String {
        get {
            return industry ?? ""
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
    
    var _skills : String {
        get {
            return skills ?? ""
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _phoneNumber : String {
        get {
            return phoneNumber ?? ""
        }
    }
    
    var _CV_URL : String {
        get {
            return CV_URL ?? ""
        }
    }
    
    var _employerName : String {
        get {
            return employerName ?? ""
        }
    }
    
    var _profilePictureURL : String {
        get {
            return profilePictureURL ?? ""
        }
    }
    
    var _currentLocation : String {
        get {
            return currentLocation ?? ""
        }
    }
    
    var _noredooPhoneNo : String {
        get {
            return noredooPhoneNo ?? ""
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
    
    var _iPDevice : String {
        get {
            return iPDevice ?? ""
        }
    }
    
    var _region : String {
        get {
            return region ?? ""
        }
    }
    
    var _addCat : String {
        get {
            return addCat ?? ""
        }
    }
    
    var _memberType : String {
        get {
            return memberType ?? ""
        }
    }
    
    var _simLocation : String {
        get {
            return simLocation ?? ""
        }
    }
    
    var _postLocation : String {
        get {
            return postLocation ?? ""
        }
    }
    
    var _allowNoredochat : String {
        get {
            return allowNoredochat ?? ""
        }
    }
    
    var _accountID : String {
        get {
            return accountID ?? ""
        }
    }
    
    var _gender : String {
        get {
            return gender ?? ""
        }
    }
    
    var _postDate : String {
        get {
            return postDate ?? ""
        }
    }
    
    var _jobSeekerID : Double {
        get {
            return jobSeekerID ?? 0
        }
    }
    
    
    init?(map: Map) {
        
    }
    
    init(){
        
    }
    
    mutating func mapping(map: Map) {
        
        employName <- map["Employ_name"]
        employType <- map["Employ_type"]
        jobTitle <- map["Job_title"]
        language <- map["Language"]
        yearOfExperience <- map["Yearofexperience"]
        industry <- map["Industry"]
        resident <- map["Resident"]
        nationality <- map["Nationality"]
        skills <- map["Skills"]
        email <- map["Email"]
        phoneNumber <- map["Phone_number"]
        CV_URL <- map["CV_URL"]
        employerName <- map["Employer_name"]
        profilePictureURL <- map["Profile_pictureURL"]
        currentLocation <- map["Current_location"]
        noredooPhoneNo <- map["Noredoo_phoneNo"]
        iD_emp <- map["ID_emp"]
        expairedDate <- map["ExpairedDate"]
        iPDevice <- map["IP_device"]
        region <- map["Region"]
        addCat <- map["Add_Cat"]
        memberType <- map["Member_Type"]
        simLocation <- map["Sim_location"]
        postLocation <- map["post_location"]
        allowNoredochat <- map["AllowNoredochat"]
        accountID <- map["Account_ID"]
        gender <- map["gender"]
        postDate <- map["PostDate"]
        jobSeekerID <- map["Job_Seeker_ID"]
    }
    
}
