/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct MSISDN : Mappable {
    
	var country : String?
	var countryID : String?
	var operatorName : String?
	var requestID : Int?
	var msisdn : String?
	var destinationCurrency : String?
	var products : [MSISDNProduct]?
	var priceList : [String]?

    var _country: String {
        get {
            return self.country ?? ""
        }
    }
    
    var _countryID: String {
        get {
            return self.countryID ?? ""
        }
    }
    
    var _destinationCurrency: String {
        get {
            return self.destinationCurrency ?? ""
        }
    }
    
    var _operatorName: String {
        get {
            return self.operatorName ?? ""
        }
    }
    
    var _msisdn: String {
        get {
            return self.msisdn ?? ""
        }
    }
    
    var _requestID: Int {
        get {
            return self.requestID ?? -1
        }
    }
    
    var _products: [MSISDNProduct] {
        get {
            return self.products ?? []
        }
    }
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        self.country <- map["Country"]
        self.countryID <- map["CountryID"]
        self.operatorName <- map["OperatorName"]
        self.requestID <- map["RequestID"]
        self.msisdn <- map["MSISDN"]
        self.destinationCurrency <- map["DestinationCurrency"]
        self.products <- map["ProductDetail"]
        self.priceList <- map["PriceList"]
	}
}
