//
//  ConfirmForgetPasswordRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
 
class ConfirmForgetPasswordRequest : PEndpoint {
    
    var method: HTTPMethod {
        get {
            return .post
        }
    }
    var headers: HTTPHeaders?

    var path: String {
        get {
            return "api/WalletUser/ConfirmForgetPassword"
        }
    }
    
    var params: Parameters?
    
    init(requestID: Int, code: String, newPassword: String ,  headers: HTTPHeaders ,token : String ){
        self.params = [
            "RequestID" : requestID,
            "Code" : code,
            "Password" : newPassword,
            "ConfirmPassword" : newPassword,
            "LanguageId" : 1,
        ]
        self.headers = .default
        self.headers?.add(.authorization(bearerToken: token))
     }
}
