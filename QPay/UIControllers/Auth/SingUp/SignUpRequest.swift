//
//  SignUpRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 01/05/2023.
//  Copyright © 2023 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class SignUpRequest : PEndpoint {
    
    var headers: HTTPHeaders?
    
    var method: HTTPMethod {
        
        get{
            return .post
        }
    }
    
    var path: String {
        get {
            return "api/WalletUser/Register"
        }
    }
    
    var params: Parameters?
    
    init(signUpData: SignUpData, accountType: AccountType) {
        self.params = [
            "Email" : signUpData.email,
            "Password" : signUpData.password,
            "ConfirmPassword" : signUpData.confirmPassword,
            "FirstName"  : signUpData.firstName,
            "LastName"  : signUpData.lastName,
            "IDCardNumber"  : "Na",
            "UserType"  : accountType.serverAccountNumber,
            "PhoneNumber"   :"00"
        ] 
     }
    
    
}
