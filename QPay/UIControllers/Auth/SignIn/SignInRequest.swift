//
//  SignInRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignInRequest : PEndpoint {
    var method: HTTPMethod {
        get {
            return .get
        }
    }
    
    var path: String {
        get {
            return "token"
        }
    }
    
    var headers: HTTPHeaders?
    
    var params: Parameters?
    
    convenience init(email : String , password : String) {
        let params2 = [
            "username"    : email ,
            "password" : password,
            "grant_type" : "password",
            "response_type" : "token",
        ]
        self.init(params: params2)
    }
    
    init(params: Parameters, header: HTTPHeaders? = nil) {
        self.params = params
    }
}
