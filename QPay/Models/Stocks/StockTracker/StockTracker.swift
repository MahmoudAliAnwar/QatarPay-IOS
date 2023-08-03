/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct StockTracker : Mappable {
    
	var marketPrimaryInfoDetails : [MarketPrimaryInfoDetails]?
	var marketShortSummaryDetails : [MarketShortSummaryDetails]?
	var stockGroupDetails : [StockGroupDetails]?
	var success : Bool?
	var code : String?
	var message : String?
	var errors : [String]?
    
    var _marketPrimaryInfoDetails : [MarketPrimaryInfoDetails] {
        get {
            return marketPrimaryInfoDetails ?? []
        }
    }
    
    var _marketShortSummaryDetails : [MarketShortSummaryDetails] {
        get {
            return marketShortSummaryDetails ?? []
        }
    }
    
    var _stockGroupDetails : [StockGroupDetails] {
        get {
            return stockGroupDetails ?? []
        }
    }
    
    var _success : Bool {
        get {
            return success ?? false
        }
    }
    
    var _code : String {
        get {
            return code ?? ""
        }
    }
    
    var _message : String {
        get {
            return message ?? ""
        }
    }
    
    var _errors : [String] {
        get {
            return errors ?? []
        }
    }
    
	init?(map: Map) {
        
	}
    
	mutating func mapping(map: Map) {

        self.marketPrimaryInfoDetails <- map["MarketPrimaryInfoDetails"]
        self.marketShortSummaryDetails <- map["MarketShortSummaryDetails"]
        self.stockGroupDetails <- map["StockGroupDetails"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
	}
}
