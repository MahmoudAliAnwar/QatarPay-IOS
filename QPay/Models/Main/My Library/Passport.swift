/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Passport : Mappable {
    
    var id : Int?
    var number : String?
    var type : String?
    var placeOfIssue : String?
    var surName : String?
    var givenName : String?
    var dateOfBirth : String?
    var dateOfIssue : String?
    var dateOfExpiry : String?
    var reminderType : String?
    var imageLocation : String?
    
    var _number : String {
        get {
            return number ?? ""
        }
    }
    
    var _type : String {
        get {
            return type ?? ""
        }
    }
    
    var _placeOfIssue : String {
        get {
            return placeOfIssue ?? ""
        }
    }
    
    var _surName : String {
        get {
            return surName ?? ""
        }
    }
    
    var _givenName : String {
        get {
            return givenName ?? ""
        }
    }
    
    var _dateOfBirth : String {
        get {
            return dateOfBirth ?? ""
        }
    }
    
    var _dateOfIssue : String {
        get {
            return dateOfIssue ?? ""
        }
    }
    
    var _dateOfExpiry : String {
        get {
            return dateOfExpiry ?? ""
        }
    }
    
    var _reminderType : String {
        get {
            return reminderType ?? ""
        }
    }
    
    var _imageLocation : String {
        get {
            return imageLocation ?? ""
        }
                                        }
    
    init() {
        
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        self.id <- map["ID"]
        self.number <- map["PasssportNumber"]
        self.type <- map["PassportType"]
        self.placeOfIssue <- map["PlaceofIssue"]
        self.surName <- map["SurName"]
        self.givenName <- map["GivenName"]
        self.dateOfBirth <- map["DateofBirth"]
        self.dateOfIssue <- map["DateofIssue"]
        self.dateOfExpiry <- map["DateofExpiry"]
        self.reminderType <- map["ReminderType"]
        self.imageLocation <- map["PassportImageLocation"]
    }
}
