/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct MarketSummary : Mappable {
    
	var todaysDateSummaryDetails : [TodaysDateSummaryDetails]?
	var previousDateSummaryDetails : [PreviousDateSummaryDetails]?
	var up : Int?
	var down : Int?
	var unchanged : Int?
	var marketSummaryDetails : [MarketSummaryDetails]?
    
    var success : Bool?
    var code : String?
    var message : String?
    var errors : [String]?
    
    var _todaysDateSummaryDetails : [TodaysDateSummaryDetails] {
        get {
            return todaysDateSummaryDetails ?? []
        }
    }
    
    var _previousDateSummaryDetails : [PreviousDateSummaryDetails] {
        get {
            return previousDateSummaryDetails ?? []
        }
    }
    
    var _up : Int {
        get {
            return up ?? 0
        }
    }
    
    var _down : Int {
        get {
            return down ?? 0
        }
    }
    
    var _unchanged : Int {
        get {
            return unchanged ?? 0
        }
    }
    
    var _marketSummaryDetails : [MarketSummaryDetails] {
        get {
            return marketSummaryDetails ?? []
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

		todaysDateSummaryDetails <- map["TodaysDateSummaryDetails"]
		previousDateSummaryDetails <- map["PreviousDateSummaryDetails"]
		up <- map["Up"]
		down <- map["Down"]
		unchanged <- map["Unchanged"]
		marketSummaryDetails <- map["MarketSummaryDetails"]
        
        self.success <- map["success"]
        self.code <- map["code"]
        self.message <- map["message"]
        self.errors <- map["errors"]
	}
}
