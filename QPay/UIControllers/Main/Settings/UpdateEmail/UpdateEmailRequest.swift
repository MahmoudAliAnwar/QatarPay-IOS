//
//  UpdateEmailRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 02/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class UpdateEmailRequest : PEndpoint {
    
    var method : HTTPMethod {
        get {
            return .post
        }
    }
    
    var path : String {
        get {
            return ""
        }
    }
    
    var headers : HTTPHeaders?
    
    var params : Parameters?
    
    
}
