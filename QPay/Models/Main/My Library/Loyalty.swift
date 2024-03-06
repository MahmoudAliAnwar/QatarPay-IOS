/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Loyalty : Mappable {
	
    var id : Int?
	var number : String?
	var name : String?
	var brand : String?
	var cardName : String?
	var expiryDate : String?
	var reminderType : String?
	var frontSideImageLocation : String?
	var backSideImageLocation : String?
    
    var _number: String {
        get {
            return self.number ?? ""
        }
    }
    
    var _name: String {
        get {
            return self.name ?? ""
        }
    }
    
    var _brand: String {
        get {
            return self.brand ?? ""
        }
    }
    
    var _cardName: String {
        get {
            return self.cardName ?? ""
        }
    }
    
    var _expiryDate: String {
        get {
            return self.expiryDate ?? ""
        }
    }
    
    var _reminderType: String {
        get {
            return self.reminderType ?? ""
        }
    }
    
    var _frontSideImageLocation: String {
        get {
            return self.frontSideImageLocation ?? ""
        }
    }
    
    var _backSideImageLocation: String {
        get {
            return self.backSideImageLocation ?? ""
        }
    }
    
    init() {
        
    }
    
	init?(map: Map) {
        
	}
    
	mutating func mapping(map: Map) {
        
        self.id <- map["ID"]
        self.number <- map["CardNumber"]
        self.name <- map["Name"]
        self.brand <- map["Brand"]
        self.cardName <- map["CardName"]
        self.expiryDate <- map["ExpiryDate"]
        self.reminderType <- map["ReminderType"]
        self.frontSideImageLocation <- map["FrontSideImageLocation"]
        self.backSideImageLocation <- map["BackSideImageLocation"]
	}
}
