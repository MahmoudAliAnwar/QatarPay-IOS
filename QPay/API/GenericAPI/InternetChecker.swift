//
//  RequestsController.swift
//  QPay
//
//  Created by Mohammed Hamad on 07/11/2021.
//  Copyright © 2021 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SystemConfiguration

// MARK: - INTERNET CHECKER PROTOCOL

protocol PInternetChecker {
    func isConnectedToInternet() -> Bool
    func internetConnectionClousure(_ callback: @escaping InternetConnectionChecker)
}

// MARK: - INTERNET CHECKER

class InternetChecker {
    
    private init() {}
    
    public static func isConnectedToInternet() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    public static func internetConnectionClousure(_ callback: @escaping InternetConnectionChecker) {
        callback(isConnectedToInternet())
    }
}
