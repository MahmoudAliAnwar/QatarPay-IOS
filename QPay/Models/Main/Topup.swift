/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Topup: Mappable, Encodable {
    
    var id : Int?
    var cardName : String?
    var cardType : String?
    var cardNumber : String?
    var ownerName : String?
    var expiryDate : String?
    var cVV : String?
    var paymentCardType : String?
    var entryTime : String?
    var modifiedBy : Int?
    var userID : Int?
    var modifiedTime : String?
    var qPAN : String?
    var reminderType : String?
    var isDefault : Bool?
    var cardID : Int?
    
    init() {
        
    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["ID"]
        cardName <- map["CardName"]
        cardType <- map["CardType"]
        cardNumber <- map["CardNumber"]
        ownerName <- map["OwnerName"]
        expiryDate <- map["ExpiryDate"]
        cVV <- map["CVV"]
        paymentCardType <- map["PaymentCardType"]
        entryTime <- map["EntryTime"]
        modifiedBy <- map["ModifiedBy"]
        userID <- map["UserID"]
        modifiedTime <- map["ModifiedTime"]
        qPAN <- map["QPAN"]
        reminderType <- map["ReminderType"]
        isDefault <- map["IsDefault"]
        cardID <- map["CardID"]
    }
}
