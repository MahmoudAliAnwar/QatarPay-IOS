//
//  InvoiceRequests.swift
//  QPay
//
//  Created by Mohammed Hamad on 17/02/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper

typealias ModelProtocols = Mappable
typealias InvoiceCallBack<T: ModelProtocols> = (Result<T, InvoiceRequestErrors>) -> Void

class InvoiceRequestsService {
    
    private static var object: InvoiceRequestsService!
    
    public static var shared: InvoiceRequestsService {
        get {
            if object == nil {
                object = InvoiceRequestsService()
            }
            return object
        }
    }
    
    private init() {}
    
    private lazy var AlamofireManager: Session = {
        let session = Session.default
        
        session.sessionConfiguration.timeoutIntervalForRequest = 15
        session.sessionConfiguration.timeoutIntervalForResource = 15
        
        return session
    }()
    
    func send<Model: ModelProtocols>(_ request: InvoiceURLRequestBuilder, completion: @escaping InvoiceCallBack<Model>) {
        
        guard NetworkReachabilityManager()?.isReachable == true else {
            completion(.failure(.noIntenetConnection))
            return
        }
        
        self.AlamofireManager.request(request).responseObject { (response: DataResponse<Model, AFError>) in
            
            guard let resp = response.response else { return }
//            let data = response.data
//            print("Response \(String(data: data, encoding: .utf8) ?? "Empty")")
            
            guard resp.statusCode == 200 else {
                completion(.failure(self.checkStatusCode(resp.statusCode)))
                return
            }
            
            switch response.result {
            case .success(let model):
                completion(.success(model))
                break
                
            case .failure(let err):
                switch err {
                case .sessionTaskFailed(error: URLError.timedOut):
                    completion(.failure(.timedOut))
                default:
                    completion(.failure(.alamofire(err)))
                }
//                if err.responseCode == NSURLErrorTimedOut {
//                    completion(.failure(.timedOut))
//                } else {
//                    completion(.failure(.unknownError(err)))
//                }
                break
            }
        } // End Alamofire Response
    }
    
    private func checkStatusCode(_ code: Int) -> InvoiceRequestErrors {
        guard code != -1 else {
            return .unknownError
        }
        guard let statusCode = InvoiceRequestErrors.RequestStatusCodes(rawValue: code) else {
            return .unknownStatusCode(code)
        }
        return .statusCode(statusCode)
    }
}
