//
//  RequestBuilder.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    
    var baseURL: URL { get }
    
    var requestURL: URL { get }
    
    var path: String { get }
    
    var pathArgs: [String]? { get }
    
    var parameters: Parameters? { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders { get }
    
    var urlRequest: URLRequest { get }
    
    var encoding: ParameterEncoding { get }
}

extension URLRequestBuilder {
    
    var baseURL: URL {
        return URL(string: Constants.BASEURL)!
    }
    
    var requestURL: URL {
        return baseURL
            .appendingPathComponent(path.formatted(with: self.pathArgs))
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.allHTTPHeaderFields = headers.dictionary
        request.httpMethod = method.rawValue
        return request
    }
    
    var headers: HTTPHeaders {
        var headers = defaultHeaders
        let token = UserProfile.shared.kuludToken ?? ""
        headers.add(.authorization(bearerToken: token))
        return headers
    }
    
    var pathArgs: [String]? {
        return nil
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: parameters)
    }
}
