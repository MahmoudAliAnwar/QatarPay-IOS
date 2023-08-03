//
//  ForgotPasswordRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ForgotPasswordRequest : PEndpoint {
    
    var method: HTTPMethod {
        get {
            return .post
        }
    }
    
    var path: String {
        get {
            return "api/WalletUser/ForgetPassword"
        }
    }
    
    var headers: HTTPHeaders?
    
    var params: Parameters?
    
    init (email: String = "" , mobileNumber: String = "") {
        self.params = [
            "Email"        : email,
            "MobileNumber" : mobileNumber,
            "LanguageId"   : 1,
        ]
        
        guard let token = self.userProfile.getUser()?._access_token else { return }
        self.headers?.add(.authorization(bearerToken: token))
    }
}
