//
//  CreateAccountBuilder.swift
//  QPay
//
//  Created by Mohammed Hamad on 08/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct CreateAccountModel {
    var QuserName: String
    var lastName: String
    var firstName: String
    var QEmail: String
    var mobileNumber: String
    var userCode: String
    var userType: String
    var balance: String
    
    init(user: User) {
        self.QuserName = user._userName
        self.lastName = user._lastName
        self.firstName = user._firstName
        self.QEmail = user._email
        self.mobileNumber = user._mobileNumber
        self.userCode = user._userCode
        self.userType = user._userType
        self.balance = user._balance
    }
}

struct LoginModel {
    var userID: String
    var token: String
}

enum AccountBuilder {
    case create(CreateAccountModel)
    case login(LoginModel)
}

extension AccountBuilder: URLRequestBuilder {
    
    var path: String {
        switch self {
        case .create:
            return "User/CreateNewClientAccount"
        case .login:
            return "User/Login"
        }
    }
    
    var pathArgs: [String]? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .create(let model):
            return [
                "QuserName" : model.QuserName,
                "LastName" : model.lastName,
                "FirstName" : model.firstName,
                "QEmail" : model.QEmail,
                "MobileNumber" : model.mobileNumber,
                "UserCode" : model.userCode,
                "UserType" : model.userType,
                "Balance" : model.balance,
            ]
            
        case .login(let model):
            return [
                "UserId" : model.userID,
                "DeviceToken" : model.token
            ]
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
