//
//  OrderBuilder.swift
//  QPay
//
//  Created by Mohammed Hamad on 13/01/2022.
//  Copyright © 2022 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum OrderBuilder {
    case createOrder(Address)
    case getAllOrders
    case getOrderDetails(String)
}

extension OrderBuilder: URLRequestBuilder {
    
    var path: String {
        switch self {
        case .createOrder: return "Order/CreateOrder"
        case .getAllOrders: return "Order/GetAllOrders"
        case .getOrderDetails(let id): return "Order/OrderDetails/\(id)"
        }
    }
    
    var pathArgs: [String]? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .createOrder(let address):
            return address.map?.JSON ?? [:]
        case .getAllOrders, .getOrderDetails:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createOrder: return .post
        case .getAllOrders, .getOrderDetails: return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .createOrder, .getAllOrders:
            return JSONEncoding.default
        case .getOrderDetails:
            return URLEncoding.queryString
        }
    }
}
