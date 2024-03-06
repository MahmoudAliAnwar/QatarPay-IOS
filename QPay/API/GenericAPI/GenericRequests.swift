//
//  GenericRequest.swift
//  QPay
//
//  Created by Mohammed Hamad on 20/03/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import Alamofire
import SystemConfiguration

public enum MResult<M, Error> {
    case success(M)
    case failure(Error)
}

// MARK: - REQUEST MANAGER

class RequestsManager {
    
    let semaphore: DispatchSemaphore
    let group: DispatchGroup
    let queue: DispatchQueue
    
    private static var object: RequestsManager!
    
    public static var shared: RequestsManager {
        get {
            if object == nil {
                object = RequestsManager()
            }
            return object
        }
    }
    
    private init() {
        self.semaphore = DispatchSemaphore(value: 1)
        self.group = DispatchGroup()
        self.queue = DispatchQueue(label: "requests_manager_queue", qos: .background, attributes: .concurrent)
    }
}

// MARK: - REQUEST SERVICE

class GenericRequestService {
    
//    typealias RequestCompletion = (Result<M, GenericRequestError>) -> Void
    
    private init() {}
    
    public static func getInstance() -> GenericRequestService {
        return GenericRequestService()
    }
    
    private lazy var AlamofireManager: Session = {
        let session = Session.default
        
        session.sessionConfiguration.timeoutIntervalForRequest = 15
        session.sessionConfiguration.timeoutIntervalForResource = 15
        
        return session
    }()
    
    // MARK: - GET METHOD REQUEST
    
    /**
     Send request by (GET) method...

     - warning: No Warning
     
     # Parameters:
     - parameters: parameters description
     - headers: headers description
     - completion: completion description
     
     # Notes: #
     1.
     
     # Example #
     ```
     getRequest { result in
         switch result {
         case .success(let object):
         case .failure(let error):
         }
     }
     ```
     */
    public func getRequest(parameters: Parameters? = nil) {
    }
    
    // MARK: - POST REQUEST
    
    /// Send request by (Post) method...
    /// - Parameters:
    ///   - parameters: parameters description
    ///   - headers: headers description
    ///   - completion: completion description
    public func postRequest(parameters: Parameters? = nil) {
    }
    
    // MARK: - BASE REQUEST
    
    public func send(endPoint: PEndpoint,
                                         _ completion: @escaping (MResult<Data, GenericRequestError>) -> Void) {
        
        guard InternetChecker.isConnectedToInternet() else {
            DispatchQueue.main.async {
                completion(.failure(.NoInternet))
            }
            return
        }
        
        self.AlamofireManager.request(endPoint.url,
                                      method: endPoint.method,
                                      parameters: endPoint.params,
                                      headers: endPoint.headers).responseData { response in
            
            guard response.response?.statusCode != 401 else {
                completion(.failure(.UnAuthorized))
                return
            }
            
//            if let data = response.data {
//                let str = String(decoding: data, as: UTF8.self)
//                print("response \(str)")
//            }
            
            switch response.result {
            case .success(let model):
                completion(.success(model))
                break
                
            case .failure(let err):
                completion(.failure(.AFError(err)))
                break
            }
        } // End Alamofire Response
    }
} // End Request Service Class

// MARK: - REQUEST ERROR

public enum GenericRequestError: LocalizedError, Equatable {
    
    case NoInternet
    case UnAuthorized
    case AFError(AFError)
    
    public var errorDescription: String? {
        get {
            switch self {
            case .NoInternet:
                return NSLocalizedString("Check internet connection!", comment: "")
            case .UnAuthorized:
                return NSLocalizedString("You must login right now!", comment: "")
            case .AFError(let error):
                return error.localizedDescription
            }
        }
    }
    
    public static func == (lhs: GenericRequestError, rhs: GenericRequestError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

extension HTTPHeader {
    private static let jsonApplication: String = "application/json"
    
    public static var acceptJSON: HTTPHeader {
        get {
            return accept(jsonApplication)
        }
    }
    
    public static var contentTypeJSON: HTTPHeader {
        get {
            return .contentType(jsonApplication)
        }
    }
    
    public static func authorization(appToken: String) -> HTTPHeader {
        return authorization("bearer \(appToken)")
    }
}
