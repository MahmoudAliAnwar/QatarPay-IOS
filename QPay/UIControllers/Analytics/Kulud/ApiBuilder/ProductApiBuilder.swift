//
//  ProductApiBuilder.swift
//  kulud
//
//  Created by Hussam Elsadany on 04/06/2021.
//  Copyright © 2021 Qmobile-IT. All rights reserved.
//

import Alamofire

enum ProductApiBuilder {
    case getProductDetails(productId: Int)
    case addRemoveToWithList(productId: Int)
    case getWishList
}

extension ProductApiBuilder: URLRequestBuilder {
    
    var path: String {
        switch self {
        case .getProductDetails:
            return NetworkPaths.Product.productDetails
        case .addRemoveToWithList:
            return NetworkPaths.Product.addRemoveWithList
        case .getWishList:
            return NetworkPaths.Product.withList
        }
    }
    
    var pathArgs: [String]? {
        switch self {
        case .getProductDetails(let productId):
            return [String(describing: productId)]
        case .addRemoveToWithList(let productId):
            return [String(describing: productId)]
        default:
            return nil
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .addRemoveToWithList:
            return .post
        default:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .addRemoveToWithList:
            return JSONEncoding.default
        default:
            return URLEncoding(destination: .queryString)
        }
    }
}
