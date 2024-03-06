//
//  QIDRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class QIDRequest : PEndpoint {
    var headers: HTTPHeaders?
    
    
    var method: HTTPMethod {
        get {
            return .get
        }
    }
    
    var path: String {
        get {
            return "api/NoqoodyUser/GetIDCardNumber"
        }
    }
    
    var params: Parameters?
    
    init(qidNumber: String) {
        
        self.params = [
            "IDCardNumber" : qidNumber
        ]
    }
}
