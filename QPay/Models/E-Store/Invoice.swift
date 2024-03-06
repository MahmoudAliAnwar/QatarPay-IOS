/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Invoice : Mappable {
    
	var id : Int?
	var number : String?
	var customerName : String?
	var customerEmail : String?
    var customerMobile : String?
    var company : String?
    var amount : Double?
    var discountedAmount : Double?
    var date : String?
    var dueDate : String?
    var description : String?
	var otherChangesDescription : String?
	var otherCharges : Double?
	var subTotal : Double?
	var totalAmount : Double?
	var reference : String?
	var userID : Int?
	var paymentStatus : Bool?
	var paidStatus : String?
	var url : String?
	var userName : String?
	var senderFirstName : String?
	var senderLastName : String?
	var senderEmail : String?
	var senderMobileNumber : String?
    var items : [InvoiceItem]?
    var cartItems : [CartItem]?
    
    var _id : Int {
        get {
            return id ?? 0
        }
    }
    
    var _number : String {
        get {
            return number ?? ""
        }
    }
    
    var _customerName : String {
        get {
            return customerName ?? ""
        }
    }
    
    var _customerEmail : String {
        get {
            return customerEmail ?? ""
        }
    }
    
    var _customerMobile : String {
        get {
            return customerMobile ?? ""
        }
    }
    
    var _company : String {
        get {
            return company ?? ""
        }
    }
    
    var _amount : Double {
        get {
            return amount ?? 0.0
        }
    }
    
    var _discountedAmount : Double {
        get {
            return discountedAmount ?? 0.0
        }
    }
    
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
    
    var _description : String {
        get {
            return description ?? ""
        }
    }
    
    var _otherChangesDescription : String {
        get {
            return otherChangesDescription ?? ""
        }
    }
    
    var _otherCharges : Double {
        get {
            return otherCharges ?? 0.0
        }
    }
    
    var _subTotal : Double {
        get {
            return subTotal ?? 0.0
        }
    }
    
    var _totalAmount : Double {
        get {
            return totalAmount ?? 0.0
        }
    }
    
    var _reference : String {
        get {
            return reference ?? ""
        }
    }
    
    var _userID : Int {
        get {
            return userID ?? 0
        }
    }
    
    var _paymentStatus : Bool {
        get {
            return paymentStatus ?? false
        }
    }
    
    var _paidStatus : String {
        get {
            return paidStatus ?? ""
        }
    }
    
    var _url : String {
        get {
            return url ?? ""
        }
    }
    
    var _userName : String {
        get {
            return userName ?? ""
        }
    }
    
    var _senderFirstName : String {
        get {
            return senderFirstName ?? ""
        }
    }
    
    var _senderLastName : String {
        get {
            return senderLastName ?? ""
        }
    }
    
    var _senderEmail : String {
        get {
            return senderEmail ?? ""
        }
    }
    
    var _senderMobileNumber : String {
        get {
            return senderMobileNumber ?? ""
        }
    }
    
    var _items : [InvoiceItem] {
        get {
            return items ?? []
        }
    }
    
    var _cartItems: [CartItem] {
        get {
            return cartItems ?? []
        }
    }
    
    init?(map: Map) {

	}
    
    init() {
        
    }

	mutating func mapping(map: Map) {

		id <- map["InvoiceID"]
		number <- map["InvoiceNumber"]
		customerName <- map["CustomerName"]
		customerEmail <- map["CustomerEmail"]
		company <- map["Company"]
		amount <- map["Amount"]
		discountedAmount <- map["DiscountedAmount"]
		date <- map["InvoiceDate"]
		description <- map["InvoiceDescription"]
		customerMobile <- map["MobileNumber"]
		otherChangesDescription <- map["OtherChangesDescription"]
		otherCharges <- map["OtherCharges"]
		subTotal <- map["SubTotal"]
		totalAmount <- map["TotalAmount"]
		reference <- map["InvoiceReference"]
		userID <- map["UserID"]
		paymentStatus <- map["PaymentStatus"]
		paidStatus <- map["PaidStatus"]
		url <- map["InvoiceURL"]
		userName <- map["UserName"]
		senderFirstName <- map["SenderFirstName"]
		senderLastName <- map["SenderLastName"]
		senderEmail <- map["SenderEmail"]
		senderMobileNumber <- map["SenderMobileNumber"]
        dueDate <- map["InvoiceDueDate"]
		items <- map["items"]
	}
}
