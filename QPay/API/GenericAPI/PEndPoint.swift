//
//  PEndPoint.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/11/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol PEndpoint {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var params: Parameters? { get }
    
    func getTokenWithBearer(_ token: String) -> HTTPHeader
}

extension PEndpoint {
    // a default extension that creates the full URL
    var url: String {
        return "\(BASE_URL)\(path)"
    }
    
    var defHeaders: HTTPHeaders {
        get {
            var defHeaders = HTTPHeaders.default
            defHeaders.add(.acceptJSON)
            return defHeaders
        }
    }
    
    var userProfile: UserProfile {
        get {
            return UserProfile.shared
        }
    }
    
    func getTokenWithBearer(_ token: String) -> HTTPHeader {
        return .authorization(appToken: token)
    }
}
