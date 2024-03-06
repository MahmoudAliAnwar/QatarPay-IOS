//
//  Network.swift
//  kulud
//
//  Created by Hussam Elsadany on 16/05/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Foundation
import Alamofire

enum KuludResult<T> {
    case success(T)
    case failure(Error)
}

struct Network {
    
    static let shared = Network()
    private var session: Session!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.httpShouldUsePipelining = true
        self.session = Session(configuration: configuration, startRequestsImmediately: true)
    }
    
    func request<T: URLRequestBuilder, P: Codable>(request: T, completion: @escaping(_ response: KuludResult<P>) -> Void) {
        NetworkLogger.log(request)
        session.request(request).validate().responseJSON { response in
            NetworkLogger.log(response.response)
            switch response.result {
            case .success:
                let data = response.data ?? Data()
                NetworkLogger.log(response.data)
                do {
                    let obj: P = try JSONDecoder().decode(P.self, from: data)
                    completion(.success(obj))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request<T: URLRequestBuilder, P: Codable>(request: T, completion: @escaping(_ statusCode: Int, _ response: KuludResult<P>) -> Void) {
        NetworkLogger.log(request)
        session.request(request).responseJSON { response in
            NetworkLogger.log(response.response)
            let statusCode = response.response?.statusCode ?? -1
            switch response.result {
            case .success:
                let data = response.data ?? Data()
                NetworkLogger.log(response.data)
                do {
                    let obj: P = try JSONDecoder().decode(P.self, from: data)
                    completion(statusCode, .success(obj))
                } catch let error {
                    completion(statusCode, .failure(error))
                }
            case .failure(let error):
                completion(statusCode, .failure(error))
            }
        }
    }
}
