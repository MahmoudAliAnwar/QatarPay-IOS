//
//  InvoiceURLRequestBuilder.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol InvoiceURLRequestBuilder: URLRequestConvertible {
    
    var baseURL: URL { get }
    
    var requestURL: URL { get }
    
    var path: String { get }
    
    var parameters: Parameters? { get }
    
    var bodyData: Data? { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders { get }
    
    var urlRequest: URLRequest { get }
    
    var encoding: ParameterEncoding { get }
}

extension InvoiceURLRequestBuilder {
    
    var baseURL: URL {
        get {
            return URL(string: "https://noq-qrc-memportbe.azurewebsites.net/")!
//            return URL(string: "https://noqoodypay.com/sdk/")!
        }
    }
    
    var requestURL: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.allHTTPHeaderFields = headers.dictionary
        request.httpMethod = method.rawValue
        request.httpBody = bodyData
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
