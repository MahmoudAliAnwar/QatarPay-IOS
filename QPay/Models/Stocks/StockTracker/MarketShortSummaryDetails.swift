/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct MarketShortSummaryDetails : Mappable {
	
    var todaysDate : String?
	var currentIndex : Double?
	var previousIndex : Double?
	var current_difference_Amt : Double?
	var current_difference_Percntge : Double?
	var trades : Double?
	var volume : Double?
	var valueQAR : Double?
    
    var _todaysDate : String {
        get {
            return todaysDate ?? ""
        }
    }
    
    var _currentIndex : Double {
        get {
            return currentIndex ?? 0.0
        }
    }
    
    var _previousIndex : Double {
        get {
            return previousIndex ?? 0.0
        }
    }
    
    var _current_difference_Amt : Double {
        get {
            return current_difference_Amt ?? 0.0
        }
    }
    
    var _current_difference_Percntge : Double {
        get {
            return current_difference_Percntge ?? 0.0
        }
    }
    
    var _trades : Double {
        get {
            return trades ?? 0.0
        }
    }
    
    var _volume : Double {
        get {
            return volume ?? 0.0
        }
    }
    
    var _valueQAR : Double {
        get {
            return valueQAR ?? 0.0
        }
    }
    
	init?(map: Map) {
        
	}
    
	mutating func mapping(map: Map) {
		todaysDate <- map["TodaysDate"]
		currentIndex <- map["CurrentIndex"]
		previousIndex <- map["PreviousIndex"]
		current_difference_Amt <- map["Current_difference_Amt"]
		current_difference_Percntge <- map["Current_difference_Percntge"]
		trades <- map["Trades"]
		volume <- map["Volume"]
		valueQAR <- map["ValueQAR"]
	}
}
