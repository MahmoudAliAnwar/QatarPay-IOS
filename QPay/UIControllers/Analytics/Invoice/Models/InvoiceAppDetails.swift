/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct InvoiceAppDetails : Mappable {
    
	var date : String?
	var dueDate : String?
	var number : String?
	var startDate : String?
	var endDueDate : String?
	var recurringType : Int?
	var invoiceDescription : String?
	var discount : Double?
	var invoiceAmount : Double?
	var invoiceTotal : Double?
	var invoiceNote : String?
	var recipitantName : String?
	var recipitantCompany : String?
	var recipitantAddress : String?
	var recipitantEmail : String?
	var recipitantMobile : String?
	var invoiceID : Int?
	var status : String?
	var userName : String?
	var userID : Int?
	var email : String?
	var mobile : String?
	var company : String?
	var address : String?
	var logoLocation : String?
	var sessionID : String?
	var uuid : String?
	var isAcive : Bool?
	var scheduleEndTime : String?
    var onlineFee : Double?
    var taxCharges : Double?
    var deliveryCharges : Double?
    var invoiceDetails : [InvoiceAppItem]?
    
    var _date : String {
        get {
            return date ?? ""
        }
    }
    
    var _dueDate : String {
        get {
            return dueDate ?? ""
        }
    }
    
    var _number : String {
        get {
            return number ?? ""
        }
    }
    
    var _startDate : String {
        get {
            return startDate ?? ""
        }
    }
    
    var _endDueDate : String {
        get {
            return endDueDate ?? ""
        }
    }
    
    var _recurringType : Int {
        get {
            return recurringType ?? 0
        }
    }
    
    var _invoiceDescription : String {
        get {
            return invoiceDescription ?? ""
        }
    }
    
    var _discount : Double {
        get {
            return discount ?? 0.0
        }
    }
    
    var _invoiceAmount : Double {
        get {
            return invoiceAmount ?? 0.0
        }
    }
    
    var _invoiceTotal : Double {
        get {
            return invoiceTotal ?? 0.0
        }
    }
    
    var _invoiceNote : String {
        get {
            return invoiceNote ?? ""
        }
    }
    
    var _recipitantName : String {
        get {
            return recipitantName ?? ""
        }
    }
    
    var _recipitantCompany : String {
        get {
            return recipitantCompany ?? ""
        }
    }
    
    var _recipitantAddress : String {
        get {
            return recipitantAddress ?? ""
        }
    }
    
    var _recipitantEmail : String {
        get {
            return recipitantEmail ?? ""
        }
    }
    
    var _recipitantMobile : String {
        get {
            return recipitantMobile ?? ""
        }
    }
    
    var _invoiceID : Int {
        get {
            return invoiceID ?? 0
        }
    }
    
    var _status : String {
        get {
            return status ?? ""
        }
    }
    
    var _statusObject: InvoiceApp.Status? {
        get {
            return InvoiceApp.Status(rawValue: self._status)
        }
    }
    
    var _userName : String {
        get {
            return userName ?? ""
        }
    }
    
    var _userID : Int {
        get {
            return userID ?? 0
        }
    }
    
    var _email : String {
        get {
            return email ?? ""
        }
    }
    
    var _mobile : String {
        get {
            return mobile ?? ""
        }
    }
    
    var _company : String {
        get {
            return company ?? ""
        }
    }
    
    var _address : String {
        get {
            return address ?? ""
        }
    }
    
    var _logoLocation : String {
        get {
            return logoLocation ?? ""
        }
    }
    
    var _sessionID : String {
        get {
            return sessionID ?? ""
        }
    }
    
    var _uuid : String {
        get {
            return uuid ?? ""
        }
    }
    
    var _isAcive : Bool {
        get {
            return isAcive ?? false
        }
    }
    
    var _scheduleEndTime : String {
        get {
            return scheduleEndTime ?? ""
        }
    }
    
    var _onlineFee : Double {
        get {
            return onlineFee ?? 0.0
        }
    }
    
    var _taxCharges : Double {
        get {
            return taxCharges ?? 0.0
        }
    }
    
    var _deliveryCharges : Double {
        get {
            return deliveryCharges ?? 0.0
        }
    }
    
    var _invoiceDetails : [InvoiceAppItem] {
        get {
            return invoiceDetails ?? []
        }
    }
    
	init?(map: Map) {

	}
    
	mutating func mapping(map: Map) {
		date <- map["InvoiceDate"]
		dueDate <- map["InvoiceDueDate"]
		number <- map["InvoiceNo"]
		startDate <- map["StartDate"]
		endDueDate <- map["EndDueDate"]
		recurringType <- map["RecurringType"]
		invoiceDescription <- map["InvoiceDescription"]
		discount <- map["Discount"]
		invoiceAmount <- map["InvoiceAmount"]
		invoiceTotal <- map["InvoiceTotal"]
		invoiceNote <- map["InvoiceNote"]
		recipitantName <- map["RecipitantName"]
		recipitantCompany <- map["RecipitantCompany"]
		recipitantAddress <- map["RecipitantAddress"]
		recipitantEmail <- map["RecipitantEmail"]
		recipitantMobile <- map["RecipitantMobile"]
		invoiceID <- map["InvoiceID"]
		status <- map["Status"]
		userName <- map["UserName"]
		userID <- map["UserID"]
		email <- map["Email"]
		mobile <- map["Mobile"]
		company <- map["Company"]
		address <- map["Address"]
		logoLocation <- map["LogoLocation"]
		sessionID <- map["SessionID"]
		uuid <- map["UUID"]
		isAcive <- map["IsAcive"]
		scheduleEndTime <- map["ScheduleEndTime"]
		onlineFee <- map["OnlineFee"]
		taxCharges <- map["TaxCharges"]
		deliveryCharges <- map["DeliveryCharges"]
		invoiceDetails <- map["InvoiceDetails"]
	}
}
