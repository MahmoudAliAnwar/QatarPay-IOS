//
//  CartApiBuilder.swift
//  kulud
//
//  Created by Hussam Elsadany on 03/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Alamofire

enum CartApiBuilder {
    case getShoppingCart
    case addToCart(productId: Int, quantity: Int)
    case updateCart(productId: Int, quantity: Int)
}

extension CartApiBuilder: URLRequestBuilder {
    
    var path: String {
        switch self {
        case .getShoppingCart:
            return NetworkPaths.Cart.getCart
        case .addToCart:
            return NetworkPaths.Cart.addToCart
        case .updateCart:
            return NetworkPaths.Cart.updateCart
        }
    }
    
    var pathArgs: [String]? {
        switch self {
        case .addToCart(let productId, let quantity):
            return [String(describing: productId), String(describing: quantity)]
        case .updateCart(let productId, let quantity):
            return [String(describing: productId), String(describing: quantity)]
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding(destination: .queryString)
    }
}
